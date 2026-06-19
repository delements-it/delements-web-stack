#!/usr/bin/env python3
import argparse
import hashlib
import json
import shutil
import subprocess
from dataclasses import dataclass
from datetime import date, datetime, timezone
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
CONFIG_PATH = SCRIPT_DIR / "config.shopify-admin-bsi.json"


@dataclass(frozen=True)
class Config:
    source_root: Path
    source_files_root: Path
    converted_root: Path
    manifests_root: Path
    output_vault: Path
    rr_builder_root: Path
    rr_cli_bin: Path
    rr_config_path: Path
    brain_tools_root: Path
    department: str
    schema_version: str


def load_config() -> Config:
    data = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    return Config(
        source_root=Path(data["source_root"]).expanduser().resolve(),
        source_files_root=Path(data["source_files_root"]).expanduser().resolve(),
        converted_root=Path(data["converted_root"]).expanduser().resolve(),
        manifests_root=Path(data["manifests_root"]).expanduser().resolve(),
        output_vault=Path(data["output_vault"]).expanduser().resolve(),
        rr_builder_root=Path(data["rr_builder_root"]).expanduser().resolve(),
        rr_cli_bin=Path(data["rr_cli_bin"]).expanduser().resolve(),
        rr_config_path=Path(data["rr_config_path"]).expanduser().resolve(),
        brain_tools_root=Path(data["brain_tools_root"]).expanduser().resolve(),
        department=str(data["department"]),
        schema_version=str(data["schema_version"]),
    )


def ensure_dirs(*paths: Path):
    for path in paths:
        path.mkdir(parents=True, exist_ok=True)


def stable_hash(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()[:16]


def safe_stem(name: str) -> str:
    cleaned = "".join(ch if ch.isalnum() or ch in ("-", "_") else "-" for ch in name).strip("-")
    while "--" in cleaned:
        cleaned = cleaned.replace("--", "-")
    return cleaned or "note"


def scan_markdown_files(root: Path):
    return sorted(path for path in root.rglob("*.md") if path.is_file())


def build_directory_mapping(config: Config, markdown_files: list[Path]):
    records = []
    seen_dirs = set()
    now = datetime.now().astimezone().isoformat(timespec="seconds")

    def add_dir(path: Path):
        if path in seen_dirs:
            return
        seen_dirs.add(path)
        rel = "." if path == config.source_files_root else str(path.relative_to(config.source_files_root))
        depth = 0 if path == config.source_files_root else len(path.relative_to(config.source_files_root).parts)
        tree = "Source_Files" if path == config.source_files_root else "Source_Files > " + str(path.relative_to(config.source_files_root))
        records.append(
            {
                "item_type": "folder",
                "name": path.name if path != config.source_files_root else "Source_Files",
                "path": str(path),
                "relative_path": rel,
                "depth": depth,
                "tree_path": tree,
                "source_url": str(path),
                "status": "Local",
                "modified_time": now,
            }
        )

    add_dir(config.source_files_root)
    for md in markdown_files:
        for parent in [config.source_files_root, *md.relative_to(config.source_files_root).parents[:-1]]:
            add_dir(config.source_files_root / parent if isinstance(parent, Path) and parent != config.source_files_root else config.source_files_root)

    for md in markdown_files:
        rel = md.relative_to(config.source_files_root)
        parent = rel.parent
        tree = "Source_Files > " + str(rel)
        records.append(
            {
                "item_type": "file",
                "name": md.name,
                "path": str(md),
                "relative_path": str(rel),
                "depth": len(rel.parts),
                "tree_path": tree,
                "source_url": str(md),
                "status": "Local",
                "modified_time": datetime.fromtimestamp(md.stat().st_mtime).astimezone().isoformat(timespec="seconds"),
            }
        )
    return records


def build_md_index(config: Config, markdown_files: list[Path], sync_date: str):
    full_dir = config.converted_root / "full" / sync_date
    ensure_dirs(full_dir)
    records = []
    for md in markdown_files:
        rel = md.relative_to(config.source_files_root)
        file_hash = stable_hash(str(md))
        out_name = f"{safe_stem(md.stem)}__{file_hash}.md"
        out_path = full_dir / out_name
        shutil.copy2(md, out_path)
        records.append(
            {
                "input": str(md),
                "source": str(md),
                "output_path": str(out_path),
                "relative_output_path": str(out_path.relative_to(config.converted_root)),
                "backend": "file2md",
                "status": "converted",
                "error": None,
            }
        )
    return records


def write_analysis(config: Config, directory_records: list[dict], md_records: list[dict], sync_date: str):
    analysis = (
        "# Shopify Brain Source Analysis\n\n"
        f"- Sync date: {sync_date}\n"
        f"- Source notes: {len([r for r in directory_records if r['item_type'] == 'file'])}\n"
        f"- Directory records: {len(directory_records)}\n"
        f"- Converted markdown records: {len(md_records)}\n"
    )
    (config.manifests_root / "directory_analysis_current.md").write_text(analysis, encoding="utf-8")


def generate(config: Config):
    sync_date = date.today().isoformat()
    ensure_dirs(config.converted_root, config.manifests_root)
    markdown_files = scan_markdown_files(config.source_files_root)
    if not markdown_files:
        raise SystemExit(f"No markdown source files found in {config.source_files_root}")
    directory_records = build_directory_mapping(config, markdown_files)
    md_records = build_md_index(config, markdown_files, sync_date)
    (config.manifests_root / "directory_mapping_current.json").write_text(
        json.dumps(directory_records, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (config.manifests_root / "md_files_current.json").write_text(
        json.dumps(md_records, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    write_analysis(config, directory_records, md_records, sync_date)
    return {
        "sync_date": sync_date,
        "source_notes": len(markdown_files),
        "directory_records": len(directory_records),
        "converted_markdown": len(md_records),
        "directory_mapping": str(config.manifests_root / "directory_mapping_current.json"),
        "md_index": str(config.manifests_root / "md_files_current.json"),
    }


def rr_command(config: Config, *args: str):
    cmd = [str(config.rr_cli_bin), "--config", str(config.rr_config_path), *args]
    return subprocess.run(cmd, cwd=config.rr_builder_root, text=True, capture_output=True)


def require_brain_owner(args):
    if args.command == "status":
        return
    if not args.brain_owner:
        raise SystemExit("Brain owner mode required. Re-run with --brain-owner for generate/build/export/all.")


def run_status(config: Config):
    result = rr_command(config, "status")
    if result.returncode != 0:
        raise SystemExit(result.stderr or result.stdout)
    print(result.stdout.strip())
    return 0


def run_build(config: Config, fresh: bool):
    args = ["build"]
    if fresh:
        args.append("--fresh")
    result = rr_command(config, *args)
    if result.returncode != 0:
        raise SystemExit(result.stderr or result.stdout)
    print(result.stdout.strip())
    return 0


def run_export(config: Config):
    result = rr_command(config, "export-integrations")
    if result.returncode != 0:
        raise SystemExit(result.stderr or result.stdout)
    print(result.stdout.strip())
    return 0


def parse_args():
    parser = argparse.ArgumentParser(description="Build Shopify Admin BSI Obsidian brain inputs and vault.")
    parser.add_argument(
        "--brain-owner",
        action="store_true",
        help="Required for any command that mutates source manifests or the built Shopify brain vault.",
    )
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("generate", help="Generate directory mapping and markdown index manifests.")
    build = sub.add_parser("build", help="Run rr-obsidian-brain build.")
    build.add_argument("--fresh", action="store_true", help="Rebuild the output vault from scratch.")
    sub.add_parser("export", help="Run rr-obsidian-brain export-integrations.")
    all_cmd = sub.add_parser("all", help="Generate manifests, build, and export integrations.")
    all_cmd.add_argument("--fresh", action="store_true", help="Rebuild the output vault from scratch.")
    sub.add_parser("status", help="Print builder status for the Shopify config.")
    return parser.parse_args()


def main():
    args = parse_args()
    require_brain_owner(args)
    config = load_config()
    if args.command == "generate":
        print(json.dumps(generate(config), ensure_ascii=False, indent=2))
        return 0
    if args.command == "status":
        return run_status(config)
    if args.command == "build":
        return run_build(config, args.fresh)
    if args.command == "export":
        return run_export(config)
    if args.command == "all":
        print(json.dumps(generate(config), ensure_ascii=False, indent=2))
        run_build(config, args.fresh)
        return run_export(config)
    raise SystemExit(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    raise SystemExit(main())
