# Quick Start - delements-web-stack

## Cài đặt nhanh (5 phút)

```bash
# 1. Clone repository
git clone https://github.com/delements/delements-web-stack.git
cd delements-web-stack

# 2. Tạo file secrets
cp env/.env.example env/.env

# 3. Chỉnh sửa env/.env với thông tin thực:
#    - SHOPIFY_ACCESS_TOKEN=***
#    - SHOPIFY_DOMAIN=your-store.myshopify.com
#    - WEBFLOW_TOKEN=***
#    - FIGMA_USER_ID=your_figma_user_id

# 4. Kiểm tra dependencies
make preflight

# 5. Cài đặt toàn bộ stack
make all

# 6. Khởi động OpenClaw
openclaw gateway start
```

## Cài đặt từng phần

```bash
# Chỉ Figma
make figma

# Chỉ Webflow
make webflow

# Chỉ Shopify
make shopify

# Chỉ Agents
make agents

# Copy local programs
make local-programs

# Setup auth profiles
make auth

# Setup plugins
make plugins
```

## Sau khi cài đặt

### Figma
1. Mở Figma Desktop
2. Import plugin: `$FIGMA_MCP_DIR/plugin/manifest.json`
3. Mở plugin trong design file

### Webflow
1. Verify token: `openclaw agent bsi-webflow-mcp`
2. Test: "List my Webflow sites"

### Shopify
1. Login: `shopify auth login --store your-store.myshopify.com`
2. Test: `openclaw agent bsi-shopify-mcp`
3. Hỏi: "List products from my store"

## Troubleshooting nhanh

```bash
# Kiểm tra toàn bộ
make verify

# Xem logs
openclaw gateway logs

# Restart gateway
openclaw gateway restart

# Reset và cài lại
make clean
make all
```

## Tài liệu chi tiết

- [Architecture](docs/architecture.md) - Tổng quan hệ thống
- [Figma Setup](docs/figma-setup.md) - Hướng dẫn Figma chi tiết
- [Webflow Setup](docs/webflow-setup.md) - Hướng dẫn Webflow chi tiết
- [Shopify Setup](docs/shopify-setup.md) - Hướng dẫn Shopify chi tiết
- [Troubleshooting](docs/troubleshooting.md) - Xử lý sự cố

## Push lên GitHub

```bash
# Tạo repo trên GitHub trước, sau đó:
git remote add origin https://github.com/delements/delements-web-stack.git
git branch -M main
git push -u origin main
```

## Trên máy mới

```bash
git clone https://github.com/delements/delements-web-stack.git
cd delements-web-stack
cp env/.env.example env/.env
# Chỉnh sửa env/.env
make all
```

Done! 🚀
