# Data Link Dashboard

## By SKU / Product Code

```dataview
TABLE sku_codes, niches, product_stages, source_path
FROM "02_Source_Documents"
WHERE length(sku_codes) > 0
```

## By Product Stage

```dataview
TABLE rows.file.link AS Files
FROM "02_Source_Documents"
FLATTEN product_stages AS stage
GROUP BY stage
```

## By Niche

```dataview
TABLE rows.file.link AS Files
FROM "02_Source_Documents"
FLATTEN niches AS niche
GROUP BY niche
```

## By Material

```dataview
TABLE rows.file.link AS Files
FROM "02_Source_Documents"
FLATTEN materials AS material
GROUP BY material
```
