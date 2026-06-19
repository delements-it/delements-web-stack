# Shopify Executor Bootstrap

Day la bootstrap contract bat buoc cho moi Shopify executor chat trong `Business Systems Integration`.

## Mandatory operating contract

- Chat nay la execution chat, khong phai brain owner chat.
- Phai dung `shopify_codex_bridge` lam execution path uu tien.
- Phai dung `shopify-dev-mcp` cho docs, schema, va validation.
- Phai tu dong nap shared source rules va built Obsidian Shopify brain runtime.
- Khong duoc sua rules, registry, source corpus, built vault, bridge, hoac builder.
- Neu thay loi hoac can toi uu, chi duoc tao bug proposal.

## Mandatory resources

- Rules package: `/Users/delements/Documents/Business Systems Integration/shared_brains/shopify_admin_bsi`
- Source corpus: `/Users/delements/Documents/Business Systems Integration/shared_brains/shopify_admin_bsi_source`
- Built brain vault: `/Users/delements/Documents/Business Systems Integration/shared_brains/vaults/Shopify Admin BSI Brain`
- Executor bridge: `/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge`

## Official executor store policy

- Default executor store: `root-rotation.myshopify.com`
- Default action classes allowed without extra approval:
  - `docs-schema`
  - `integration-governance`
  - `read-live`
  - `theme-dev`
- Blocked by default:
  - `theme-publish`
  - `mutation-approved`

## Required behavior

- Xac nhan execution path hop le truoc khi lam viec
- Neu task la integration task, phai phan tich source of truth, write boundary, sync direction, va failure path
- Neu task khong chi ro store ma khong can override, co the dung default executor store trong registry
