# Shopify Brain Builder

Pipeline nay chuan hoa source corpus Shopify trong `Business Systems Integration` thanh dau vao hop le cho `rr-obsidian-brain`, sau do goi builder de tao vault Obsidian.

## Thanh phan

- `pipeline.py`: generate manifests va goi `rr-obsidian-brain`
- `config.shopify-admin-bsi.json`: config pipeline
- `rr-config.shopify-admin-bsi.json`: config truyen vao `rr-obsidian-brain`
- `shopify-brain`: launcher script

## Cach dung

Sinh manifest:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_brain_builder/pipeline.py" --brain-owner generate
```

Build fresh vault:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_brain_builder/pipeline.py" --brain-owner build --fresh
```

Generate + build + export:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_brain_builder/pipeline.py" --brain-owner all --fresh
```

Kiem tra builder status:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_brain_builder/pipeline.py" status
```

## Rule

- `status` la command read-only
- `generate`, `build`, `export`, va `all` chi duoc chay khi co `--brain-owner`
