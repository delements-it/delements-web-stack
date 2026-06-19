# Shopify Admin BSI Rules

## Mandatory Rules

1. Khong gia dinh default store neu `STORE_REGISTRY.json` chua khai bao va prompt chua chi ro.
2. Khong coi `shopify-dev-mcp` la live store control layer.
3. Live store actions phai di qua `Shopify CLI` hoac local program da route vao CLI.
4. Khong mutation neu chua qua read-only confirmation hoac chua nam trong run profile cho phep.
5. Khong sua package brain nay tu execution chats.
6. Neu thay bug hoac rule gap, chi duoc tao proposal trong `proposals/`.
7. Neu task la integration task, phai neu ro source of truth, write boundary, sync direction, failure path.
8. Chi role `Shopify Brain Owner` moi duoc cap nhat rules package, source corpus, built brain vault, bridge, builder, bootstrap, hoac registry.
9. `Admin BSI` la authority de phe duyet thay doi governance cho package nay.

## Classification Rules

Moi task Shopify phai duoc phan vao mot trong cac nhom:

- `docs-schema`
- `read-live`
- `mutation-approved`
- `theme-dev`
- `theme-publish`
- `integration-governance`

## Mutation Guardrails

- Chi duoc mutation khi:
  - store ro rang
  - run profile cho phep
  - prompt hoac user instruction ro rang
  - co rollback hoac recovery note neu tac dong den production state

## Theme Guardrails

- Theme preview, pull, dev, va push dev theme duoc xem la task co rui ro trung binh.
- Theme publish vao live theme mac dinh bi chan cho toi khi co explicit approval.

## Registry Guardrails

- Execution chats khong duoc them, sua, xoa store trong `STORE_REGISTRY.json`.
- Neu thay thieu store hoac policy sai, tao proposal.

## Owner Guardrails

- Owner chat duoc cap nhat he thong nen, nhung phai giu ro tach biet voi executor path.
- Moi thay doi governance quan trong nen cap nhat bootstrap, prompt, va chat config lien quan.
- Khong mo quyen cho executor vuot qua run profile neu chua co policy ro rang.
