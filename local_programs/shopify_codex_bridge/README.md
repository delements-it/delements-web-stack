# Shopify Codex Bridge

Local program nay nhan prompt Shopify, mo Shopify bang Chrome profile `IT Helpdesk`, va route task sang `Codex` theo context `Admin BSI`.

## Muc tieu

- Dung `shopify-dev-mcp` trong cac run Codex de tra docs, schema, va validate.
- Dung session browser san co cua profile `IT Helpdesk` khi can login Shopify.
- Dung `Shopify CLI` cho live store auth va Admin GraphQL execute.
- Giu context governance cua `Business Systems Integration` cho cac task Shopify trong scope.
- Luon nap shared brain cua Shopify trong `Business Systems Integration`.
- Khoi execution chats sua brain; neu gap loi chi tao proposal.

## Tep chinh

- `config.json`: shared config cua local program
- `cli.py`: CLI chinh
- `chrome_profile_browser.sh`: browser launcher dung Chrome profile `IT Helpdesk`
- `shopify-codex`: launcher script
- `shared_brains/shopify_admin_bsi`: package brain dung chung
- `.state.json`: duoc tao sau khi auth, live test, hoac run

## Cach dung

Kiem tra trang thai:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" status
```

Mo Shopify Admin voi profile `IT Helpdesk`:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" admin
```

Mo Shopify Admin cua mot store cu the:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" admin --store your-store.myshopify.com
```

Auth store that bang session browser `IT Helpdesk`:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" store-auth --store your-store.myshopify.com
```

Test live read:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" store-test --store your-store.myshopify.com
```

Chay query truc tiep:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" store-execute --store your-store.myshopify.com --query "query { shop { name myshopifyDomain } }"
```

Gui task Shopify cho Codex:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" run "Kiem tra scope tich hop Shopify cho sync inventory sang WMS." --store your-store.myshopify.com
```

Tao bug proposal ma khong sua brain:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" proposal --kind bug --title "Missing run profile" --summary "Can bo sung profile rieng cho liquid read-only checks."
```

Xem truoc prompt/command ma khong chay:

```bash
python3 "/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/cli.py" run "List nhung luong live can auth truoc." --dry-run
```

Hoac dung launcher:

```bash
"/Users/delements/Documents/Business Systems Integration/local_programs/shopify_codex_bridge/shopify-codex" status
```

## Ghi chu van hanh

- Program nay khong gia lap click tren giao dien Shopify Admin.
- `shopify-dev-mcp` phuc vu docs/schema/validation; live store access di qua `shopify store auth` va `shopify store execute`.
- `store-auth` dung bien moi truong `BROWSER` tro toi `chrome_profile_browser.sh`, de Shopify login mo bang dung profile `IT Helpdesk`.
- Nen bat dau bang read scopes, sau do moi mo rong write scopes khi workflow thuc su can.
- Shared brain la read-only voi execution chats. Chi tao proposal trong `shared_brains/shopify_admin_bsi/proposals/`.
