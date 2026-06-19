# Line Connection Audit

## Purpose

This index stores direct line-level edges from markdown source notes to business nodes such as SKUs, MOs, wikilinks, URLs, frontmatter fields, and inline fields.

## Outputs

- SQLite DB: `$BSI_ROOT/shared_brains/vaults/Shopify Admin BSI Brain/07_AI_Index/Graph_Exports/line_connections.sqlite`

## Counts

- Sources indexed: `11`
- Line connections: `373`

## Retrieval Rule

Use this DB when an answer needs exact source line evidence. Query by node value, then open only the returned file and line if more context is needed.
