# Changelog

## Unreleased

- Guides in Simplified Chinese, Japanese, Spanish, French, German and Brazilian Portuguese (README.<lang>.md), with a language switcher
- MCP_GUIDE.md: connect `https://www.supdropshipping.com/mcp` as a remote MCP server with browser sign-in (OAuth), no install

## 0.2.0

- Browser sign-in: `ai_api_request.sh login` / `ai_api_request.ps1 login` connect an account without copying a key
- Billing logs: `reference_number`, linked `orders`, and `balance_after`; `order_number` also finds batch payments
- Orders and connected products keep store and shipping method names after a store is disconnected
- Non-GET requests return a 405 JSON error
- USER_GUIDE.md: step-by-step guide from connecting an account to everyday questions

## 0.1.0

- Initial release
- Shared rules and request helper for macOS/Linux and Windows
- Skills: dashboard, orders, products, inventory, billing logs, invoices, sourcing
- Installers for macOS, Linux, and Windows
