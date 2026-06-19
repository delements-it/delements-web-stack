# Statement of Work
## Tích hợp NotebookLM MCP vào Antigravity
### Version 1.0 | 2026-06-19

---

## 1. Mục Tiêu

Tích hợp Google NotebookLM vào hệ thống Antigravity (Codex + OpenClaw) qua MCP protocol, cho phép AI agent truy vấn tri thức có trích dẫn nguồn, nạp dữ liệu mới, và tạo audio overview — phục vụ workflow research, competitor analysis, và content production.

### Mục tiêu cụ thể

| # | Mục tiêu | Đo lường |
|---|----------|----------|
| G1 | Kết nối NotebookLM MCP server với Antigravity | `get_health` trả về `authenticated: true` |
| G2 | Truy vấn tri thức có citation | `ask_question` với `source_format: footnotes` trả về answer + sources |
| G3 | Nạp nguồn dữ liệu mới vào notebook | `add_source` với URL/text thành công |
| G4 | Tạo và tải audio overview | `generate_audio` + `download_audio` hoàn tất |
| G5 | Chuẩn hóa 3 workflow mẫu | End-to-end chạy được không lỗi |

### Ngoài scope

- Không xây dựng ETL pipeline production
- Không triển khai scheduler dài hạn (cron/n8n) — chỉ demo manual trigger
- Không tích hợp multi-account (chỉ dùng 1 Google account)
- Không xây UI riêng — vận hành qua chat interface của Antigravity

---

## 2. Kiến Trúc

### 2.1 High-level architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User (chat interface)                  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│              Antigravity (Orchestration Layer)            │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │   Codex      │  │   OpenClaw   │  │  Local Scripts │  │
│  │  (Reasoning) │  │  (Execution) │  │  (Post-proc.)  │  │
│  └──────┬───────┘  └──────┬───────┘  └───────┬────────┘  │
│         └─────────────────┼──────────────────┘           │
└───────────────────────────┼─────────────────────────────┘
                            │ MCP protocol (stdio)
                            ▼
┌─────────────────────────────────────────────────────────┐
│         NotebookLM MCP Server (v2.0.0)                   │
│  ┌──────────────┐  ┌───────────────┐  ┌──────────────┐  │
│  │  Query Tools  │  │ Library Tools │  │  Auth Tools  │  │
│  └──────┬───────┘  └──────┬────────┘  └──────┬───────┘  │
│         └─────────────────┼──────────────────┘           │
│                           │ Patchright (Chromium)         │
│                           ▼                               │
│  ┌────────────────────────────────────────────────────┐  │
│  │           Chrome Browser (headless)                  │  │
│  │         ↕ DOM interaction ↕                         │  │
│  │         notebooklm.google.com                       │  │
│  └────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Component responsibilities

| Component | Vai trò | Tech |
|-----------|---------|------|
| **Antigravity (Codex)** | Đọc yêu cầu, lập kế hoạch, reasoning, điều phối | GPT-5.5 / Claude |
| **Antigravity (OpenClaw)** | Thực thi tasks, file I/O, scheduling, multi-agent | GPT-5.4-mini |
| **NotebookLM MCP** | Knowledge grounding, citation, audio generation | TypeScript, Chrome |
| **Workspace** | Inputs, outputs, reports, code | Local filesystem |
| **AGENTS.md / context.md** | Quy tắc doanh nghiệp, giọng văn, constraints | Markdown |

### 2.3 Data flow

```
User request
    ↓
Antigravity đọc AGENTS.md + context.md (quy tắc)
    ↓
Antigravity gọi get_health (kiểm tra kết nối)
    ↓
Antigravity gọi list_notebooks → select_notebook
    ↓
Antigravity gọi ask_question (source_format: footnotes)
    ↓
Antigravity post-process: format report, generate code, etc.
    ↓
Lưu output vào workspace
```

### 2.4 Workspace structure

```
antigravity-workspace/
├── AGENTS.md              # Quy tắc làm việc, giọng văn, constraints
├── context.md             # Ngữ cảnh doanh nghiệp (domain, audience, goals)
├── inputs/                # Dữ liệu đầu vào (URLs, transcripts, briefs)
├── outputs/               # Kết quả (reports, briefs, summaries)
├── audio/                 # Audio overview files
├── reports/               # Báo cáo tổng hợp
├── code/                  # Generated code (dashboards, apps)
└── logs/                  # Execution logs
```

---

## 3. Scope of Work — Antigravity

### 3.1 Antigravity CHỊU trách nhiệm

| # | Nhiệm vụ | Chi tiết |
|---|----------|----------|
| A1 | Đọc yêu cầu người dùng | Parse intent, extract entities (notebook, question, output format) |
| A2 | Nạp quy tắc làm việc | Đọc `AGENTS.md`, `context.md` trước mỗi tác vụ |
| A3 | Quyết định gọi NotebookLM | Khi nào cần knowledge grounding vs. khi nào dùng LLM thuần |
| A4 | Gọi MCP tools | `ask_question`, `add_source`, `generate_audio`, `download_audio`, etc. |
| A5 | Post-processing | Format report, generate code, build dashboard, export Markdown/DOCX |
| A6 | Ghi file đầu ra | Lưu vào workspace đúng thư mục chuẩn |
| A7 | Phối hợp MCP khác | GitHub, Notion, Google Drive nếu workflow yêu cầu |
| A8 | Error handling | Retry khi Chrome fail, fallback khi auth expired |
| A9 | Logging | Ghi log mỗi tác vụ: input, output, duration, errors |

### 3.2 Antigravity KHÔNG chịu trách nhiệm

| # | Việc | Lý do |
|---|------|--------|
| N1 | Đọc hiểu bám nguồn | NotebookLM + Gemini đảm nhận, Antigravity chỉ nhận kết quả |
| N2 | ETL pipeline production | NotebookLM MCP không đủ ổn định cho production volume |
| N3 | Scheduler dài hạn | Cần orchestration layer riêng (cron/n8n/GitHub Actions) |
| N4 | Giả định API ổn định | NotebookLM dùng Chrome automation, DOM có thể thay đổi |
| N5 | Thay thế NotebookLM UI | Chỉ điều khiển qua MCP, không rebuild tính năng |

### 3.3 Decision tree — Khi nào gọi NotebookLM

```
Nhận yêu cầu từ user
    │
    ├─ Câu hỏi cần nguồn cụ thể?
    │   ├─ YES → ask_question (citation mode)
    │   └─ NO → Dùng LLM thuần (Codex/OpenClaw)
    │
    ├─ Cần nạp dữ liệu mới?
    │   ├─ YES → add_source (URL hoặc text)
    │   └─ NO → Skip
    │
    ├─ Cần audio summary?
    │   ├─ YES → generate_audio + download_audio
    │   └─ NO → Skip
    │
    └─ Cần tạo report/app?
        ├─ YES → Dùng insight từ NotebookLM → generate code/markdown
        └─ NO → Trả kết quả trực tiếp
```

---

## 4. Quy Trình Thực Hiện Tác Vụ

### 4.1 Tác vụ điển hình — 7 bước

```
Bước 1: NHẬN MỤC TIÊU
├─ Input: User request (text)
├─ Output: Parsed intent + parameters
└─ Example: "Đọc notebook đối thủ và viết báo cáo 1 trang"

Bước 2: NẠP QUY TẮC
├─ Input: AGENTS.md, context.md
├─ Output: Working rules (giọng văn, constraints, citation format)
└─ Example: giọng chuyên nghiệp, ưu tiên chi phí, luôn trích nguồn

Bước 3: KIỂM TRA KẾT NỐI
├─ Tool: get_health
├─ If authenticated=false → setup_auth (chỉ lần đầu)
├─ If error → report + stop
└─ Output: Connection status

Bước 4: CHỌN KHO TRI THỨC
├─ Tool: list_notebooks → select_notebook
├─ Input: notebook name/id từ user hoặc context
├─ Output: Active notebook set
└─ Fallback: Nếu không tìm thấy → search_notebooks

Bước 5: TRUY VẤN TRI THỨC
├─ Tool: ask_question
├─ Parameters: question, source_format (footnotes/json)
├─ Output: Answer + citations
└─ Provenance: _provenance envelope tự động attached

Bước 6: XỬ LÝ HẬU KỲ
├─ Report: Format Markdown, thêm citations, export DOCX
├─ App: Generate code từ insight (React/Python dashboard)
├─ Audio: generate_audio + download_audio
└─ Summary: Bullet points, key findings

Bước 7: XUẤT KẾT QUẢ
├─ Lưu vào workspace (outputs/, reports/, audio/)
├─ Log execution (duration, tokens, errors)
└─ Optional: Push to GitHub/Drive/Notion
```

### 4.2 Workflow types

| Type | Tools used | Read/Write | Risk |
|------|-----------|------------|------|
| **Research brief** | `ask_question` | Read-only | Low |
| **Transcript ingestion** | `add_source` (text) | Write | Medium |
| **URL ingestion** | `add_source` (url) | Write | Medium |
| **Audio generation** | `generate_audio` + `download_audio` | Read + Write | Low |
| **Competitor report** | `ask_question` + post-process | Read-only | Low |
| **Dashboard scaffold** | `ask_question` + code generation | Read + Write | Medium |
| **Notebook management** | `add_notebook`, `update_notebook` | Write | High |

### 4.3 Error handling

| Error | Detection | Action |
|-------|-----------|--------|
| Auth expired | `get_health` → `authenticated: false` | Gọi `re_auth` + notify user |
| Chrome fail | MCP error / timeout | Retry 1 lần, nếu vẫn fail → report error |
| Notebook not found | `get_notebook` returns 404 | `search_notebooks` hoặc ask user |
| DOM changed | `ask_question` returns empty/error | Log error, notify maintainer |
| Answer timeout | > 600s (default) | Fail fast, report to user |
| Session leak | `list_sessions` shows stale sessions | `close_session` rồi retry |

---

## 5. Công Việc Chi Tiết Theo Pha

### Pha 1: Kết Nối Nền (Tuần 1-2)

| # | Task | Owner | Output | Duration |
|---|------|-------|--------|----------|
| 1.1 | Install NotebookLM MCP server | Antigravity | `npx notebooklm-mcp@latest` chạy được | 0.5 ngày |
| 1.2 | Setup auth (login Google) | Human + Antigravity | Chrome profile với cookies | 0.5 ngày |
| 1.3 | Tạo workspace structure | Antigravity | Thư mục chuẩn | 0.5 ngày |
| 1.4 | Viết AGENTS.md | Human | Quy tắc làm việc | 1 ngày |
| 1.5 | Viết context.md | Human | Ngữ cảnh doanh nghiệp | 1 ngày |
| 1.6 | Register MCP trong Antigravity config | Antigravity | `openclaw.json` hoặc `.codex/mcp.json` | 0.5 ngày |
| 1.7 | Health check end-to-end | Antigravity | `get_health` + `list_notebooks` OK | 0.5 ngày |
| 1.8 | Viết integration script | Antigravity | `scripts/11-setup-notebooklm.sh` | 1 ngày |

**Exit criteria**: `get_health` trả về `authenticated: true`, `list_notebooks` trả về ít nhất 1 notebook.

### Pha 2: Chuẩn Hóa Workflow (Tuần 3-4)

| # | Task | Owner | Output | Duration |
|---|------|-------|--------|----------|
| 2.1 | Workflow: Research brief | Antigravity | Template + example run | 2 ngày |
| 2.2 | Workflow: Transcript ingestion | Antigravity | Template + example run | 1 ngày |
| 2.3 | Workflow: Competitor watch | Antigravity | Template + example run | 2 ngày |
| 2.4 | Workflow: Audio generation | Antigravity | Template + example run | 1 ngày |
| 2.5 | Workflow: Dashboard scaffold | Antigravity | Template + example run | 2 ngày |
| 2.6 | Citation post-processing | Antigravity | Script format citations | 1 ngày |
| 2.7 | Error handling + retry logic | Antigravity | Error wrapper script | 1 ngày |

**Exit criteria**: 3 workflow mẫu chạy end-to-end thành công, output lưu đúng thư mục.

### Pha 3: Vận Hành Hóa (Tuần 5-6)

| # | Task | Owner | Output | Duration |
|---|------|-------|--------|----------|
| 3.1 | Guardrails ngữ cảnh | Human + Antigravity | Rules file bổ sung | 1 ngày |
| 3.2 | Logging + monitoring | Antigravity | Log format + dashboard | 1 ngày |
| 3.3 | Notebook access control | Antigravity | Allowlist notebook IDs | 0.5 ngày |
| 3.4 | Runbook vận hành | Human + Antigravity | Runbook.md | 1 ngày |
| 3.5 | Risk register | Human + Antigravity | Risks.md | 0.5 ngày |
| 3.6 | Demo + training | Human | Video/screenshots | 1 ngày |

**Exit criteria**: Runbook hoàn chỉnh, team biết cách vận hành, risk register có mitigation plans.

---

## 6. RACI Matrix

| Hoạt động | Human (Owner) | Antigravity (Codex) | Antigravity (OpenClaw) | NotebookLM MCP |
|-----------|:---:|:---:|:---:|:---:|
| Viết AGENTS.md / context.md | **R/A** | C | I | - |
| Install MCP server | A | **R** | C | - |
| Setup auth (login Google) | **R** | C | I | **R** |
| Gọi ask_question | I | **R** | C | **R** |
| Post-process report | A | C | **R** | - |
| Generate audio | I | C | **R** | **R** |
| Add source (URL/text) | **A** | **R** | C | **R** |
| Error handling + retry | I | C | **R** | - |
| Logging + monitoring | I | C | **R** | - |
| Scheduler (future) | **A** | C | **R** | - |

**Legend**: R = Responsible, A = Accountable, C = Consulted, I = Informed

---

## 7. Acceptance Criteria

### 7.1 Per-workflow

| Workflow | Criteria | Verification |
|----------|----------|--------------|
| **Research brief** | Answer có ≥ 1 citation, format footnotes, lưu vào `outputs/` | Manual check |
| **Transcript ingestion** | Source added, `get_notebook` shows updated source count | Tool call verification |
| **Competitor watch** | Report ≥ 500 từ, ≥ 3 citations, lưu vào `reports/` | Manual check |
| **Audio generation** | File .mp3 tồn tại trong `audio/`, duration > 0 | File check |
| **Dashboard scaffold** | Code chạy được (Python/React), dùng insight từ notebook | Run code |

### 7.2 System-level

| Criterion | Measurement |
|-----------|-------------|
| Health check pass rate | ≥ 95% over 20 runs |
| Auth persistence | ≥ 7 ngày không cần re_auth |
| Query latency | p50 < 30s, p95 < 60s |
| Error recovery | Auto-retry thành công ≥ 80% |
| Citation accuracy | ≥ 90% citations trỏ đúng source |

---

## 8. Rủi Ro Và Phương Án Giảm Thiểu

| # | Rủi ro | Xác suất | Tác động | Giảm thiểu |
|---|--------|----------|----------|------------|
| R1 | Google update NotebookLM UI → DOM selectors hỏng | **Cao** | **Cao** | Pin version MCP server, monitor changelog, có fallback plan (Gemini API trực tiếp) |
| R2 | Auth cookies expire sớm | **Trung bình** | **Trung bình** | Health check trước mỗi workflow, auto-notify khi cần re_auth |
| R3 | Google flag/ban account vì automation | **Thấp** | **Rất cao** | Dùng account riêng (không phải account chính), stealth mode ON, giới hạn frequency |
| R4 | Query timeout (> 600s) | **Trung bình** | **Thấp** | ANSWER_TIMEOUT_MS configurable, fail fast + retry |
| R5 | Chrome crash / memory leak | **Trung bình** | **Trung bình** | MAX_SESSIONS=3, SESSION_TIMEOUT=300s, auto-cleanup |
| R6 | Citation không chính xác | **Trung bình** | **Trung bình** | Dùng source_format=json để verify, human review cho critical reports |
| R7 | ToS violation (scraping) | **Thấp** | **Cao** | Dùng account dedicated, không expose data public, tuân thủ rate limiting |
| R8 | Google release official API → server obsolete | **Thấp** | **Thấp** | Architecture modular, dễ swap sang official API khi có |

---

## 9. Deliverables

| # | Deliverable | Format | Pha |
|---|-------------|--------|-----|
| D1 | Workspace Antigravity đã kết nối NotebookLM MCP | Working system | 1 |
| D2 | Bộ file ngữ cảnh chuẩn (AGENTS.md + context.md) | Markdown | 1 |
| D3 | 3 workflow mẫu chạy được end-to-end | Templates + examples | 2 |
| D4 | Script setup tự động (11-setup-notebooklm.sh) | Bash | 1 |
| D5 | Runbook vận hành | Markdown | 3 |
| D6 | Risk register + mitigation plans | Markdown | 3 |
| D7 | Integration vào delements-web-stack repo | Git commits | 1-3 |

---

## 10. Timeline

```
Tuần 1-2: Pha 1 (Kết nối nền)
├─ Install + auth + workspace
├─ AGENTS.md + context.md
└─ Health check pass

Tuần 3-4: Pha 2 (Chuẩn hóa workflow)
├─ Research brief workflow
├─ Transcript ingestion workflow
├─ Competitor watch workflow
└─ Error handling

Tuần 5-6: Pha 3 (Vận hành hóa)
├─ Guardrails + logging
├─ Runbook + risk register
└─ Demo + training
```

---

## 11. Phụ Lục

### 11.1 NotebookLM MCP — Tool reference

| Tool | Purpose | Risk level |
|------|---------|------------|
| `get_health` | Check auth + sessions | Read-only |
| `setup_auth` | First-time Google login | Write (cookies) |
| `list_notebooks` | List all notebooks | Read-only |
| `select_notebook` | Set active notebook | Read-only |
| `ask_question` | Query notebook with citations | Read-only |
| `add_source` | Add URL/text to notebook | **Write** |
| `generate_audio` | Create audio overview | **Write** |
| `download_audio` | Save audio to disk | Write (local) |
| `add_notebook` | Add notebook to library | **Write** (needs confirm) |
| `update_notebook` | Update metadata | **Write** |
| `remove_notebook` | Remove from library | **Write** |
| `list_sessions` | List browser sessions | Read-only |
| `close_session` | Close browser session | Write |
| `reset_session` | Clear chat history | Write |
| `re_auth` | Wipe auth + re-login | **Write** |
| `cleanup_data` | Delete all stored data | **Write (destructive)** |

### 11.2 Environment variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `HEADLESS` | `true` | Chrome headless mode |
| `ANSWER_TIMEOUT_MS` | `600000` | Max wait for answer (10 min) |
| `BROWSER_TIMEOUT` | `30000` | Per-action timeout |
| `MAX_SESSIONS` | `10` | Max concurrent sessions |
| `SESSION_TIMEOUT` | `900` | Idle timeout (15 min) |
| `NOTEBOOKLM_PROFILE` | `full` | Tool profile (minimal/standard/full) |
| `NOTEBOOKLM_AI_MARKER` | `true` | AI-generated prefix on answers |
| `NOTEBOOKLM_ACCOUNT` | (unset) | Multi-account slug |

### 11.3 Related documents

- [MCP Introduction](https://modelcontextprotocol.io/docs/getting-started/intro)
- [MCP Architecture](https://modelcontextprotocol.io/docs/learn/architecture)
- [MCP Tools Spec](https://modelcontextprotocol.io/specification/2025-06-18/server/tools)
- [NotebookLM MCP README](https://github.com/PleasePrompto/notebooklm-mcp)
- [NotebookLM MCP Tools](https://github.com/PleasePrompto/notebooklm-mcp/blob/main/docs/tools.md)
- [delements-web-stack Architecture](./architecture.md)
