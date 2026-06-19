# Supplier Registry Index

```dataview
TABLE source_path, workflow_stage, kanban_status
FROM "02_Source_Documents"
WHERE domain = "supplier_factory" OR domain = "sourcing" OR domain = "material"
```
