# Connector Retrieval Audit

## Finding

The previous connector surface was metadata-heavy. It exposed source files and graph links, but did not give connectors a compact row-level or chunk-level retrieval target for SKU, stock, and table questions.

## New Connector Exports

- Connector JSONL: `/Users/delements/Documents/Business Systems Integration/shared_brains/vaults/Shopify Admin BSI Brain/07_AI_Index/connector_retrieval_index.jsonl`
- SKU inventory JSON: `/Users/delements/Documents/Business Systems Integration/shared_brains/vaults/Shopify Admin BSI Brain/07_AI_Index/Graph_Exports/sku_inventory_index.json`
- SKU fast lookup JSON: `/Users/delements/Documents/Business Systems Integration/shared_brains/vaults/Shopify Admin BSI Brain/07_AI_Index/Graph_Exports/sku_fast_lookup.json`

## Counts

- Sources: `11`
- Sources with readable markdown body: `11`
- Markdown chunks: `11`
- Parsed markdown tables: `0`
- Connector records: `11`
- SKU table rows: `0`
- Unique SKU evidence rows: `0`
- Distinct SKU keys: `0`

## Source Types

- `md`: `11`

## Connector Rule

For business questions, prefer `sku_fast_lookup.json` first, then `sku_inventory_index.json`, then `connector_retrieval_index.jsonl`, then full source markdown as evidence fallback.
