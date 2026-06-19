---
id: "gdrive_366425f4accc600a"
source_url: "/Users/delements/Documents/Business Systems Integration/shared_brains/shopify_admin_bsi_source/source_files/02_Operations/Shopify MCP and CLI Architecture.md"
source_path: "Source_Files > 02_Operations/Shopify MCP and CLI Architecture.md"
source_type: "md"
department: "Shopify Admin BSI Brain"
domain: "production_management"
workflow_stage: "planned"
kanban_status: "ready"
lean_type: "value_stream"
mo_code: ""
modified_time: "2026-06-12T14:29:48+07:00"
sync_date: "2026-06-12"
sku_codes: []
niches: []
product_stages: []
materials: []
suppliers_factories: []
tags: ["dept/source-data", "domain/production_management", "stage/planned", "status/ready"]
---
# Shopify MCP and CLI Architecture.md

- Domain: `production_management`
- Kanban status: `ready`
- Source path: `Source_Files > 02_Operations/Shopify MCP and CLI Architecture.md`
- Google source: /Users/delements/Documents/Business Systems Integration/shared_brains/shopify_admin_bsi_source/source_files/02_Operations/Shopify MCP and CLI Architecture.md

---

# Shopify MCP and CLI Architecture

## Layer 1: Shopify Dev MCP

Dung cho:

- docs lookup
- API understanding
- GraphQL validation
- theme validation
- component validation

Khong dung layer nay de khang dinh da co live store access.

## Layer 2: Shopify CLI

Dung cho:

- `shopify store auth`
- `shopify store execute`
- theme workflows
- app workflows

Day moi la live operation path cho store that.

## Layer 3: Local program

`shopify_codex_bridge` la execution bridge dung chung cho:

- prompt injection
- Business context injection
- profile `IT Helpdesk`
- MCP + CLI routing
