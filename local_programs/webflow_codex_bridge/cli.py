#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
CONFIG_PATH = SCRIPT_DIR / "config.json"
STATE_PATH = SCRIPT_DIR / ".state.json"
URL_RE = re.compile(r"https://\S+")


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


def run_command(cmd, cwd=None, check=False, capture_output=True):
    return subprocess.run(
        cmd,
        cwd=cwd,
        check=check,
        text=True,
        capture_output=capture_output,
    )


def read_chrome_profiles():
    local_state = Path.home() / "Library/Application Support/Google/Chrome/Local State"
    if not local_state.exists():
        return {}
    data = load_json(local_state, {})
    return data.get("profile", {}).get("info_cache", {})


def read_mcp_server(config):
    cmd = [config["codex_bin"], "mcp", "get", config["mcp_server_name"]]
    result = run_command(cmd)
    return {
        "ok": result.returncode == 0,
        "stdout": result.stdout.strip(),
        "stderr": result.stderr.strip(),
        "returncode": result.returncode,
    }


def find_token_files():
    auth_root = Path.home() / ".mcp-auth"
    if not auth_root.exists():
        return []
    matches = []
    for pattern in ("*token*.json", "*tokens*.json"):
        matches.extend(auth_root.rglob(pattern))
    return sorted({str(path) for path in matches})


def find_auth_artifacts():
    auth_root = Path.home() / ".mcp-auth"
    if not auth_root.exists():
        return []
    patterns = ("*_client_info.json", "*_code_verifier.txt", "*_lock.json")
    files = []
    for pattern in patterns:
        files.extend(auth_root.rglob(pattern))
    return sorted(str(path) for path in files)


def status_payload(config, state):
    profiles = read_chrome_profiles()
    server = read_mcp_server(config)
    token_files = find_token_files()
    auth_artifacts = find_auth_artifacts()
    profile_info = profiles.get(config["chrome_profile_directory"], {})
    return {
        "config_path": str(CONFIG_PATH),
        "state_path": str(STATE_PATH),
        "codex_bin": config["codex_bin"],
        "mcp_server_name": config["mcp_server_name"],
        "mcp_server": server,
        "chrome_profile_directory": config["chrome_profile_directory"],
        "chrome_profile_found": bool(profile_info),
        "chrome_profile_name": profile_info.get("name"),
        "chrome_profile_user": profile_info.get("user_name"),
        "token_files": token_files,
        "auth_artifacts": auth_artifacts,
        "last_auth_success_at": state.get("last_auth_success_at"),
        "last_run_at": state.get("last_run_at"),
        "default_workdir": config["default_workdir"],
        "shared_context_files": config["shared_context_files"],
    }


def open_in_chrome_profile(config, url):
    cmd = [
        "open",
        "-na",
        config["chrome_app"],
        "--args",
        f"--profile-directory={config['chrome_profile_directory']}",
        url,
    ]
    subprocess.run(cmd, check=True)


def open_dashboard(config):
    open_in_chrome_profile(config, config["webflow_dashboard_url"])


def print_status(payload, as_json):
    if as_json:
        print(json.dumps(payload, indent=2))
        return
    print("Webflow Codex Bridge status")
    print(f"- Config: {payload['config_path']}")
    print(f"- MCP server: {payload['mcp_server_name']}")
    print(f"- MCP configured: {payload['mcp_server']['ok']}")
    print(f"- Chrome profile: {payload['chrome_profile_directory']}")
    print(
        f"- Chrome profile user: "
        f"{payload.get('chrome_profile_user') or '(not found)'}"
    )
    print(f"- Token files found: {len(payload['token_files'])}")
    print(f"- Auth artifacts found: {len(payload['auth_artifacts'])}")
    print(f"- Last auth success: {payload['last_auth_success_at'] or '(none)'}")
    print(f"- Last run: {payload['last_run_at'] or '(none)'}")
    print("")
    if payload["mcp_server"]["stdout"]:
        print(payload["mcp_server"]["stdout"])


def auth_webflow(config, state):
    cmd = [config["codex_bin"], "mcp", "login", config["mcp_server_name"]]
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )

    opened_url = None
    assert process.stdout is not None
    for raw_line in process.stdout:
        line = raw_line.rstrip("\n")
        print(line)
        if opened_url is None:
            match = URL_RE.search(line)
            if match:
                opened_url = match.group(0)
                open_in_chrome_profile(config, opened_url)
                print(
                    f"[Local programming] Opened OAuth URL in "
                    f"{config['chrome_profile_label']} ({config['chrome_profile_email']})."
                )

    returncode = process.wait()
    if returncode == 0:
        state["last_auth_success_at"] = now_iso()
        save_json(STATE_PATH, state)
    else:
        state["last_auth_failure_at"] = now_iso()
        save_json(STATE_PATH, state)
    return returncode


def ensure_context_files(config):
    missing = [path for path in config["shared_context_files"] if not Path(path).exists()]
    if missing:
        missing_text = "\n".join(f"- {path}" for path in missing)
        raise SystemExit(f"Missing shared context files:\n{missing_text}")


def build_prompt(config, task):
    preamble = "\n".join(f"- {line}" for line in config["prompt_preamble"])
    context_files = "\n".join(f"- {path}" for path in config["shared_context_files"])
    return (
        "Shared Webflow MCP local program context:\n"
        f"{preamble}\n\n"
        "Shared context files:\n"
        f"{context_files}\n\n"
        "User task:\n"
        f"{task}\n"
    )


def run_codex_task(config, state, task, workdir=None, extra_args=None):
    ensure_context_files(config)
    prompt = build_prompt(config, task)
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
    ]
    if extra_args:
        cmd.extend(extra_args)
    cmd.append(prompt)
    state["last_run_at"] = now_iso()
    state["last_run_workdir"] = workdir or config["default_workdir"]
    save_json(STATE_PATH, state)
    completed = subprocess.run(cmd)
    return completed.returncode


def parse_args():
    parser = argparse.ArgumentParser(
        description="Shared local Webflow MCP bridge for Codex and Admin BSI."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    status_parser = subparsers.add_parser("status", help="Show config and auth status.")
    status_parser.add_argument("--json", action="store_true", help="Emit JSON output.")

    subparsers.add_parser(
        "dashboard", help="Open the Webflow dashboard in the IT Helpdesk Chrome profile."
    )

    subparsers.add_parser(
        "auth",
        help="Start Webflow MCP OAuth and open the authorization URL in the IT Helpdesk profile.",
    )

    run_parser = subparsers.add_parser(
        "run",
        help="Send a Webflow task to Codex using the shared Admin BSI config.",
    )
    run_parser.add_argument("task", help="The Webflow task prompt.")
    run_parser.add_argument(
        "--workdir",
        help="Optional override for the Codex working directory.",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    config = load_json(CONFIG_PATH, {})
    state = load_json(STATE_PATH, {})

    if args.command == "status":
        print_status(status_payload(config, state), args.json)
        return 0
    if args.command == "dashboard":
        open_dashboard(config)
        print(
            f"[Local programming] Opened Webflow dashboard in "
            f"{config['chrome_profile_label']} ({config['chrome_profile_email']})."
        )
        return 0
    if args.command == "auth":
        return auth_webflow(config, state)
    if args.command == "run":
        return run_codex_task(config, state, args.task, workdir=args.workdir)
    raise SystemExit(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    sys.exit(main())
