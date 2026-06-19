# QC Index

```dataview
TABLE source_path, workflow_stage, kanban_status
FROM "02_Source_Documents"
WHERE domain = "qc_qa"
```
