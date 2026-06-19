# Shopify Admin BSI Playbooks

## 1. Docs and Schema

- Dung khi can hieu dung Admin API, metafields, functions, theme, app config
- Route:
  - local program `run`
  - Codex su dung `shopify-dev-mcp`
- Khong can live auth

## 2. Live Read

- Muc tieu: doc shop info, products, inventory, orders, customers, metafields
- Dieu kien:
  - store ro rang
  - da auth store hoac xac nhan auth con hieu luc
- Route:
  - `store-auth` neu can
  - `store-test`
  - `store-execute`

## 3. Mutation

- Muc tieu: thay doi data tren store
- Dieu kien:
  - task ro rang
  - store ro rang
  - explicit approval
  - dung run profile `mutation-approved`
- Route:
  - validate GraphQL truoc
  - read check truoc
  - mutation sau

## 4. Theme Workflow

- Muc tieu: lam viec voi storefront theme
- Route:
  - theme list
  - theme pull
  - theme dev
  - theme push
- Theme publish live phai xem la explicit approval task

## 5. Integration Governance

- Muc tieu: danh gia Shopify trong luong BSI voi WMS, Zoho, Base, CRM, ManyChat
- Bat buoc:
  - source of truth
  - sync direction
  - write boundary
  - retry/reconciliation

## 6. Brain Bug Proposal

- Neu execution chat gap bug trong bridge, registry, rules, hoac prompt injection:
  - khong sua brain
  - tao proposal moi trong `proposals/`
  - de Brain Owner review
