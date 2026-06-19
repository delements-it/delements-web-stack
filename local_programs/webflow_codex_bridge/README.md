# Webflow Codex Bridge

Local program nay gom cau hinh dung chung cho `Webflow MCP`, Chrome profile `IT Helpdesk`, va `Codex exec` de xu ly prompt Webflow theo context `Admin BSI`.

## Muc tieu

- Dung `codex mcp login webflow` theo luong native cua Codex.
- Mo URL OAuth bang dung Chrome profile `Profile 3` (`it.helpdesk@delements.co`) de tan dung session Webflow san co.
- Nhan prompt va chuyen sang `codex exec` voi shared context cua `Business Systems Integration`.

## Tep chinh

- `config.json`: shared config cua local program
- `cli.py`: CLI chinh
- `webflow-codex`: launcher script
- `.state.json`: duoc tao sau khi chay auth hoac run

## Cach dung

Kiem tra trang thai:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/webflow_codex_bridge/cli.py" status
```

Mo dashboard Webflow bang profile `IT Helpdesk`:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/webflow_codex_bridge/cli.py" dashboard
```

Bat dau auth Webflow MCP:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/webflow_codex_bridge/cli.py" auth
```

Gui task Webflow cho Codex:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/webflow_codex_bridge/cli.py" run "List my Webflow sites and summarize which ones look relevant to Admin BSI."
```

Hoac dung launcher:

```bash
"/Users/delements/Documents/Business Systems Integration/local_programs/webflow_codex_bridge/webflow-codex" status
```

## Ghi chu van hanh

- Program nay khong tu y gia lap thao tac Webflow. No dua vao `Codex` de thinking va dua vao `Webflow MCP` neu tool da callable trong run do.
- Neu Webflow MCP chua auth xong, hay chay `auth` truoc.
- Shared context hien tai doc:
  - `/Users/delements/Documents/Business Systems Integration/AGENTS.md`
  - `/Users/delements/Documents/Business Systems Integration/PROJECT_CONTEXT.md`
