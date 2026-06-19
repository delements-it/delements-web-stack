# Shopify Admin BSI Brain

## Authority

- Owner cua package nay la `Business Systems Integration`.
- Shopify trong package nay duoc xem la mot he thong tham gia trong BSI-owned integrations.
- Package nay khong chuyen ownership governance sang mot project Shopify doc lap.
- `Admin BSI` la approval authority cho governance trong package nay.
- `Shopify Brain Owner` la role duoc phep cap nhat package nay theo owner workflow.

## Execution Model

Execution chats phai:

1. Doc package nay truoc khi lam viec Shopify
2. Dung local program `shopify_codex_bridge` lam entrypoint uu tien
3. Dung `shopify-dev-mcp` cho docs, schema, validation
4. Dung `Shopify CLI` cho live store auth va live Admin GraphQL actions
5. Tuan thu `RUN_PROFILES.json` va `RULES.md`

Owner chats phai:

1. Dung package nay nhu governance root cho Shopify trong `Admin BSI`
2. Chi cap nhat rule, registry, source corpus, built brain, bridge, hoac builder khi co ly do ro rang
3. Giu ro role separation giua owner va executor
4. Rebuild va kiem tra lai bootstrap/prompt neu thay doi anh huong execution chats
5. Ghi ro policy thay doi va pham vi anh huong khi release cap nhat

## Read-Only Contract

Execution chats:

- duoc doc package nay
- khong duoc sua package nay
- neu thay loi hoac cho can toi uu, chi duoc tao proposal trong `proposals/`

Owner chats:

- duoc doc package nay
- duoc sua package nay khi chat dang hoat dong voi role `Shopify Brain Owner`
- khong duoc bo qua owner workflow va role boundary

## Governance Frame

Moi task Shopify trong BSI nen co the tra loi cac cau hoi:

1. He thong nao lien quan
2. Entity hoac transaction nao lien quan
3. Source of truth la gi
4. Quyen ghi nam o dau
5. Huong sync nao duoc phep
6. Failure path va reconciliation path la gi
7. Owner van hanh cua workflow la ai
