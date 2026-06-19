# Shopify Admin BSI Shared Brain

Package nay la shared governance + brain package cho cac chat Shopify trong `Business Systems Integration`.

## Muc tieu

- Giu mot bo rule chung cho Shopify trong pham vi `Admin BSI`
- Lam source of truth cho governance, safety, run profiles, va playbooks
- Tach ro `Shopify Brain Owner` va `Shopify Executor`
- Cho phep execution chats doc rule va thuc thi cong viec qua local program
- Khong cho execution chats sua brain package; chi `Shopify Brain Owner` moi duoc update package nay

## Tep chinh

- `BRAIN.md`: operating model tong quan
- `RULES.md`: rule bat buoc cho execution chats
- `PLAYBOOKS.md`: luong thao tac chuan
- `STORE_REGISTRY.json`: dang ky store va ownership
- `RUN_PROFILES.json`: profile thuc thi theo muc rui ro
- `BRAIN_OWNER_BOOTSTRAP.md`: bootstrap bat buoc cho owner chat
- `SHOPIFY_BRAIN_OWNER_CHAT_CONFIG.json`: cau hinh role owner
- `SHOPIFY_BRAIN_OWNER_CHAT_PROMPT.md`: prompt chuan de khoi tao owner chat
- `EXECUTOR_BOOTSTRAP.md`: bootstrap bat buoc cho executor chat
- `SHOPIFY_EXECUTOR_CHAT_CONFIG.json`: cau hinh role executor
- `SHOPIFY_EXECUTOR_CHAT_PROMPT.md`: prompt chuan de khoi tao executor chat

## Role Model

- `Shopify Brain Owner`
  - authority: `Admin BSI`
  - duoc phep sua rules package, source corpus, built brain vault, bridge, builder, va registry theo owner workflow
  - duoc phep rebuild va phat hanh lai he thong
- `Shopify Executor`
  - authority: `Admin BSI`
  - duoc phep dung brain va local bridge de thuc thi cong viec Shopify
  - khong duoc sua brain package; chi duoc tao proposal

## Proposal

Neu execution chat phat hien bug hoac co de xuat toi uu:

- khong sua cac tep brain nay
- tao proposal moi vao `proposals/`
- de Brain Owner review sau

Neu owner chat can thay doi he thong:

- cap nhat package nay theo owner workflow
- rebuild neu can
- kiem tra lai registry, bootstrap, va role boundary truoc khi phat hanh
