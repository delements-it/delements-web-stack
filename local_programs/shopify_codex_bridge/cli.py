#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
CONFIG_PATH = SCRIPT_DIR / "config.json"
STATE_PATH = SCRIPT_DIR / ".state.json"


def load_json(path: Path, default):
    if not path.exists():
        return default
    with path.open() as handle:
        return json.load(handle)


def save_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w") as handle:
        json.dump(data, handle, indent=2)
        handle.write("\n")


def now_iso():
    return datetime.now(timezone.utc).isoformat()


def run_command(cmd, cwd=None, check=False, capture_output=True, env=None):
    return subprocess.run(
        cmd,
        cwd=cwd,
        check=check,
        text=True,
        capture_output=capture_output,
        env=env,
    )


def read_chrome_profiles():
    local_state = Path.home() / "Library/Application Support/Google/Chrome/Local State"
    if not local_state.exists():
        return {}
    data = load_json(local_state, {})
    return data.get("profile", {}).get("info_cache", {})


def read_mcp_server(config):
    result = run_command([config["codex_bin"], "mcp", "get", config["mcp_server_name"]])
    return {
        "ok": result.returncode == 0,
        "stdout": result.stdout.strip(),
        "stderr": result.stderr.strip(),
        "returncode": result.returncode,
    }


def read_shopify_version():
    result = run_command(["shopify", "version"])
    return {
        "ok": result.returncode == 0,
        "stdout": result.stdout.strip(),
        "stderr": result.stderr.strip(),
        "returncode": result.returncode,
    }


def load_store_registry(config):
    path = Path(config["store_registry_file"])
    if not path.exists():
        return {}
    return load_json(path, {})


def official_default_store(config):
    registry = load_store_registry(config)
    return registry.get("default_executor_store") or config.get("default_store") or ""


def ensure_context_files(config):
    missing = [path for path in config["shared_context_files"] if not Path(path).exists()]
    if missing:
        missing_text = "\n".join(f"- {path}" for path in missing)
        raise SystemExit(f"Missing shared context files:\n{missing_text}")


def ensure_brain_files(config):
    missing = [path for path in config["brain_files"] if not Path(path).exists()]
    if missing:
        missing_text = "\n".join(f"- {path}" for path in missing)
        raise SystemExit(f"Missing shared brain files:\n{missing_text}")
    runtime_missing = [path for path in config.get("brain_runtime_files", []) if not Path(path).exists()]
    if runtime_missing:
        missing_text = "\n".join(f"- {path}" for path in runtime_missing)
        raise SystemExit(f"Missing brain runtime files:\n{missing_text}")


def brain_permissions(config):
    results = []
    for raw_path in config["brain_files"]:
        path = Path(raw_path)
        results.append(
            {
                "path": str(path),
                "exists": path.exists(),
                "writable": os.access(path, os.W_OK),
            }
        )
    return results


def ensure_store(store: str):
    if not store:
        raise SystemExit("A Shopify store domain is required.")
    if not store.endswith(".myshopify.com"):
        raise SystemExit("Store must use the original *.myshopify.com domain.")
    return store


def browser_env(config):
    env = os.environ.copy()
    env["BROWSER"] = config["browser_launcher"]
    return env


def open_in_chrome_profile(config, url):
    subprocess.run(
        [
            "open",
            "-na",
            config["chrome_app"],
            "--args",
            f"--profile-directory={config['chrome_profile_directory']}",
            url,
        ],
        check=True,
    )


def shop_admin_url(store: str | None):
    if store:
        return f"https://{store}/admin"
    return "https://admin.shopify.com"


def open_admin(config, store: str | None):
    open_in_chrome_profile(config, shop_admin_url(store))


def status_payload(config, state):
    profiles = read_chrome_profiles()
    profile_info = profiles.get(config["chrome_profile_directory"], {})
    permissions = brain_permissions(config)
    registry = load_store_registry(config)
    return {
        "config_path": str(CONFIG_PATH),
        "state_path": str(STATE_PATH),
        "codex_bin": config["codex_bin"],
        "mcp_server_name": config["mcp_server_name"],
        "mcp_server": read_mcp_server(config),
        "shopify_cli": read_shopify_version(),
        "chrome_profile_directory": config["chrome_profile_directory"],
        "chrome_profile_found": bool(profile_info),
        "chrome_profile_name": profile_info.get("name"),
        "chrome_profile_user": profile_info.get("user_name"),
        "chrome_profile_email": config["chrome_profile_email"],
        "browser_launcher": config["browser_launcher"],
        "default_store": official_default_store(config),
        "store_registry_file": config["store_registry_file"],
        "store_registry_summary": registry,
        "default_workdir": config["default_workdir"],
        "shared_context_files": config["shared_context_files"],
        "brain_root": config["brain_root"],
        "brain_files": config["brain_files"],
        "brain_runtime_files": config.get("brain_runtime_files", []),
        "brain_permissions": permissions,
        "brain_read_only_ok": all(item["exists"] and not item["writable"] for item in permissions),
        "proposal_dir": config["proposal_dir"],
        "last_auth_success_at": state.get("last_auth_success_at"),
        "last_auth_store": state.get("last_auth_store"),
        "last_test_success_at": state.get("last_test_success_at"),
        "last_test_store": state.get("last_test_store"),
        "last_run_at": state.get("last_run_at"),
        "last_run_store": state.get("last_run_store"),
    }


def print_status(payload, as_json):
    if as_json:
        print(json.dumps(payload, indent=2))
        return
    print("Shopify Codex Bridge status")
    print(f"- Config: {payload['config_path']}")
    print(f"- MCP server: {payload['mcp_server_name']}")
    print(f"- MCP configured: {payload['mcp_server']['ok']}")
    print(f"- Shopify CLI ready: {payload['shopify_cli']['ok']}")
    print(f"- Chrome profile: {payload['chrome_profile_directory']}")
    print(
        f"- Chrome profile user: "
        f"{payload.get('chrome_profile_user') or '(not found)'}"
    )
    print(f"- Default store: {payload.get('default_store') or '(none)'}")
    print(f"- Brain root: {payload['brain_root']}")
    print(f"- Brain read-only: {payload['brain_read_only_ok']}")
    print(f"- Proposal dir: {payload['proposal_dir']}")
    print(f"- Last auth success: {payload['last_auth_success_at'] or '(none)'}")
    print(f"- Last auth store: {payload['last_auth_store'] or '(none)'}")
    print(f"- Last live test: {payload['last_test_success_at'] or '(none)'}")
    print(f"- Last live test store: {payload['last_test_store'] or '(none)'}")
    print(f"- Last run: {payload['last_run_at'] or '(none)'}")
    print(f"- Last run store: {payload['last_run_store'] or '(none)'}")
    print("")
    if payload["mcp_server"]["stdout"]:
        print(payload["mcp_server"]["stdout"])
    if payload["shopify_cli"]["stdout"]:
        print(payload["shopify_cli"]["stdout"])


def build_prompt(config, task, store: str | None):
    preamble = "\n".join(f"- {line}" for line in config["prompt_preamble"])
    context_files = "\n".join(f"- {path}" for path in config["shared_context_files"])
    brain_files = "\n".join(f"- {path}" for path in config["brain_files"])
    runtime_files = "\n".join(f"- {path}" for path in config.get("brain_runtime_files", []))
    protected_paths = "\n".join(f"- {path}" for path in config["protected_paths"])
    store_line = store or official_default_store(config) or "(not specified)"
    return (
        "Shared Shopify MCP local program context:\n"
        f"{preamble}\n\n"
        "Shared context files:\n"
        f"{context_files}\n\n"
        "Shared Shopify brain files (read-only):\n"
        f"{brain_files}\n\n"
        "Built brain runtime artifacts:\n"
        f"{runtime_files}\n\n"
        "Forbidden write paths:\n"
        f"{protected_paths}\n\n"
        "Proposal output path for bugs or system improvements:\n"
        f"- {config['proposal_dir']}\n\n"
        "Executor bootstrap contract:\n"
        f"- {config['executor_bootstrap_file']}\n\n"
        "Live store preference:\n"
        f"- {store_line}\n\n"
        "User task:\n"
        f"{task}\n"
    )


def run_codex_task(config, state, task, store=None, workdir=None, dry_run=False):
    ensure_context_files(config)
    ensure_brain_files(config)
    prompt = build_prompt(config, task, store)
    cmd = [
        config["codex_bin"],
        "exec",
        "--skip-git-repo-check",
        "-C",
        workdir or config["default_workdir"],
        "-m",
        config["default_model"],
        "-s",
        config["default_sandbox"],
        prompt,
    ]
    if dry_run:
        print(json.dumps({"command": cmd, "prompt": prompt}, indent=2))
        return 0
    state["last_run_at"] = now_iso()
    state["last_run_store"] = store or official_default_store(config)
    save_json(STATE_PATH, state)
    completed = subprocess.run(cmd)
    return completed.returncode


def ensure_proposal_dir(config):
    path = Path(config["proposal_dir"])
    path.mkdir(parents=True, exist_ok=True)
    return path


def make_slug(text):
    slug = "".join(ch.lower() if ch.isalnum() else "-" for ch in text).strip("-")
    while "--" in slug:
        slug = slug.replace("--", "-")
    return slug or "proposal"


def create_proposal(config, kind, title, summary):
    proposal_dir = ensure_proposal_dir(config)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    filename = f"{kind.upper()}-{stamp}-{make_slug(title)[:60]}.md"
    path = proposal_dir / filename
    body = (
        f"# {kind.title()} Proposal\n\n"
        f"- Title: {title}\n"
        f"- Created at: {now_iso()}\n"
        f"- Status: proposed\n"
        f"- Brain package: {config['brain_root']}\n\n"
        "## Summary\n\n"
        f"{summary.strip()}\n\n"
        "## Impact\n\n"
        "- Affected area:\n"
        "- Risk level:\n"
        "- Reproduction:\n\n"
        "## Suggested change\n\n"
        "- Proposed fix:\n"
        "- Requires brain owner review: yes\n"
    )
    path.write_text(body)
    print(path)
    return 0


def print_bootstrap(config):
    path = Path(config["executor_bootstrap_file"])
    print(path.read_text(encoding="utf-8").strip())
    return 0


def print_brain_owner_bootstrap(config):
    path = Path(config["brain_owner_bootstrap_file"])
    print(path.read_text(encoding="utf-8").strip())
    return 0


def print_executor_prompt(config, task=None):
    path = Path(config["executor_prompt_file"])
    text = path.read_text(encoding="utf-8")
    if task:
        text = text.replace("<ĐIỀN TASK SHOPIFY Ở ĐÂY>", task)
    print(text.strip())
    return 0


def print_brain_owner_prompt(config, task=None):
    path = Path(config["brain_owner_prompt_file"])
    text = path.read_text(encoding="utf-8")
    if task:
        text = text.replace("<ĐIỀN TASK SHOPIFY BRAIN OWNER Ở ĐÂY>", task)
    print(text.strip())
    return 0


def clear_legacy_state(state):
    for key in ("last_auth_success_at", "last_auth_store", "last_test_success_at", "last_test_store", "last_run_store"):
        state.pop(key, None)
    save_json(STATE_PATH, state)
    return 0


def auth_store(config, state, store, scopes):
    store = ensure_store(store)
    cmd = ["shopify", "store", "auth", "--store", store, "--scopes", scopes]
    completed = subprocess.run(cmd, env=browser_env(config))
    if completed.returncode == 0:
        state["last_auth_success_at"] = now_iso()
        state["last_auth_store"] = store
        save_json(STATE_PATH, state)
    return completed.returncode


def live_test(config, state, store):
    store = ensure_store(store)
    cmd = [
        "shopify",
        "store",
        "execute",
        "--store",
        store,
        "--query",
        "query { shop { name myshopifyDomain } }",
    ]
    completed = subprocess.run(cmd)
    if completed.returncode == 0:
        state["last_test_success_at"] = now_iso()
        state["last_test_store"] = store
        save_json(STATE_PATH, state)
    return completed.returncode


def execute_query(config, store, query, variables_json=None, allow_mutations=False):
    store = ensure_store(store)
    cmd = [
        "shopify",
        "store",
        "execute",
        "--store",
        store,
        "--query",
        query,
    ]
    if variables_json:
        cmd.extend(["--variables", variables_json])
    if allow_mutations:
        cmd.append("--allow-mutations")
    return subprocess.run(cmd).returncode


def parse_args():
    parser = argparse.ArgumentParser(
        description="Shared local Shopify MCP bridge for Codex and Admin BSI."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    status_parser = subparsers.add_parser("status", help="Show config and auth status.")
    status_parser.add_argument("--json", action="store_true", help="Emit JSON output.")

    admin_parser = subparsers.add_parser(
        "admin", help="Open Shopify Admin in the IT Helpdesk Chrome profile."
    )
    admin_parser.add_argument("--store", help="Optional *.myshopify.com store domain.")

    auth_parser = subparsers.add_parser(
        "store-auth",
        help="Authenticate a Shopify store using the IT Helpdesk browser profile.",
    )
    auth_parser.add_argument("--store", required=True, help="Target *.myshopify.com store.")
    auth_parser.add_argument(
        "--scopes",
        default=None,
        help="Comma-separated Shopify Admin API scopes.",
    )

    test_parser = subparsers.add_parser(
        "store-test", help="Run a simple live shop query against a store."
    )
    test_parser.add_argument("--store", required=True, help="Target *.myshopify.com store.")

    exec_parser = subparsers.add_parser(
        "store-execute", help="Run a direct Admin GraphQL query against a store."
    )
    exec_parser.add_argument("--store", required=True, help="Target *.myshopify.com store.")
    exec_parser.add_argument("--query", required=True, help="GraphQL query or mutation.")
    exec_parser.add_argument(
        "--variables-json",
        help="Optional GraphQL variables JSON string.",
    )
    exec_parser.add_argument(
        "--allow-mutations",
        action="store_true",
        help="Required when sending a mutation.",
    )

    run_parser = subparsers.add_parser(
        "run",
        help="Send a Shopify task prompt to Codex using the shared Admin BSI config.",
    )
    run_parser.add_argument("task", help="The Shopify task prompt.")
    run_parser.add_argument("--store", help="Preferred *.myshopify.com store domain.")
    run_parser.add_argument("--workdir", help="Optional override for the Codex working directory.")
    run_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the generated Codex command and prompt without executing.",
    )

    proposal_parser = subparsers.add_parser(
        "proposal",
        help="Create a read-only brain bug or improvement proposal without editing the brain.",
    )
    proposal_parser.add_argument(
        "--kind",
        choices=("bug", "improvement"),
        default="bug",
        help="Proposal type.",
    )
    proposal_parser.add_argument("--title", required=True, help="Short proposal title.")
    proposal_parser.add_argument(
        "--summary",
        required=True,
        help="Short problem summary and suggested optimization direction.",
    )

    subparsers.add_parser(
        "bootstrap",
        help="Print the mandatory bootstrap contract for Shopify executor chats.",
    )

    subparsers.add_parser(
        "brain-owner-bootstrap",
        help="Print the mandatory bootstrap contract for Shopify Brain Owner chats.",
    )

    prompt_parser = subparsers.add_parser(
        "executor-prompt",
        help="Print the complete Shopify Executor chat prompt template.",
    )
    prompt_parser.add_argument(
        "--task",
        help="Optional task text to inject into the prompt template.",
    )

    owner_prompt_parser = subparsers.add_parser(
        "brain-owner-prompt",
        help="Print the complete Shopify Brain Owner chat prompt template.",
    )
    owner_prompt_parser.add_argument(
        "--task",
        help="Optional task text to inject into the owner prompt template.",
    )

    subparsers.add_parser(
        "clear-legacy-state",
        help="Remove legacy last-store fields so executor chats rely on the official registry instead.",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    config = load_json(CONFIG_PATH, {})
    state = load_json(STATE_PATH, {})

    if args.command == "status":
        print_status(status_payload(config, state), args.json)
        return 0
    if args.command == "admin":
        store = ensure_store(args.store) if args.store else None
        open_admin(config, store)
        target = store or "admin.shopify.com"
        print(
            f"[Local programming] Opened Shopify Admin for {target} in "
            f"{config['chrome_profile_label']} ({config['chrome_profile_email']})."
        )
        return 0
    if args.command == "store-auth":
        scopes = args.scopes or config["default_scopes"]
        return auth_store(config, state, args.store, scopes)
    if args.command == "store-test":
        return live_test(config, state, args.store)
    if args.command == "store-execute":
        return execute_query(
            config,
            args.store,
            args.query,
            variables_json=args.variables_json,
            allow_mutations=args.allow_mutations,
        )
    if args.command == "run":
        store = ensure_store(args.store) if args.store else official_default_store(config)
        return run_codex_task(
            config,
            state,
            args.task,
            store=store,
            workdir=args.workdir,
            dry_run=args.dry_run,
        )
    if args.command == "proposal":
        return create_proposal(config, args.kind, args.title, args.summary)
    if args.command == "bootstrap":
        return print_bootstrap(config)
    if args.command == "brain-owner-bootstrap":
        return print_brain_owner_bootstrap(config)
    if args.command == "executor-prompt":
        return print_executor_prompt(config, task=args.task)
    if args.command == "brain-owner-prompt":
        return print_brain_owner_prompt(config, task=args.task)
    if args.command == "clear-legacy-state":
        return clear_legacy_state(state)
    raise SystemExit(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    sys.exit(main())
