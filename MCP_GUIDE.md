# Connect SUP Dropshipping as an MCP Server

SUP Dropshipping also runs a remote MCP server. Any AI tool that supports remote MCP servers can connect to it directly, without installing the skills. You sign in with your SUP Dropshipping account in the browser; there is no key to copy.

```
https://www.supdropshipping.com/mcp
```

| | Skills (this repository) | MCP server |
| --- | --- | --- |
| Install | Run the installer once per computer | Add one URL in your AI tool |
| Sign in | `login` command, browser approval | Browser approval when the tool first connects |
| Works in | Tools that load agent skills (Claude Code, Codex, Cursor, ...) | Any tool with remote MCP support, including Claude and ChatGPT apps |
| Extra guidance | Workflows and reference docs for the AI | Tool descriptions and server instructions |

You can use both. They read the same data and are both read-only.

## What the AI can do

The server has ten read-only tools:

| Tool | What it returns |
| --- | --- |
| `get_account_summary` | Wallet balance, credit line, store count, order and sourcing counts |
| `list_stores` | Connected stores and their ids |
| `list_orders` / `get_order` | Orders with costs, buyer, items, packages and tracking |
| `list_connected_products` | Store products linked to SUP products, by variant |
| `list_inventory` | Private inventory on hand, per SKU and warehouse |
| `list_billing_logs` | Wallet history: payments, refunds, and the orders each one covered |
| `list_invoices` / `get_invoice` | Invoices you generated for your customers |
| `list_sourcing_requests` | Sourcing requests and SUP's replies |

Nothing can be paid, cancelled, edited or placed through the server.

## Add the server

Use the URL above in your tool. The first time the tool connects, it opens a SUP Dropshipping page in your browser. Sign in if asked, check the app name, and click **Allow**.

### Claude Code

```bash
claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp
```

Then run `/mcp` inside Claude Code, choose `sup-dropshipping`, and choose **Authenticate**.

### Codex CLI

```bash
codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp
codex mcp login sup-dropshipping
```

### Cursor

Add this to `~/.cursor/mcp.json` (all projects) or `.cursor/mcp.json` (one project), then sign in when Cursor asks:

```json
{
  "mcpServers": {
    "sup-dropshipping": {
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### VS Code (GitHub Copilot agent mode)

Add this to `.vscode/mcp.json`, then start the server from the file and sign in when asked:

```json
{
  "servers": {
    "sup-dropshipping": {
      "type": "http",
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Gemini CLI

Add this to `~/.gemini/settings.json`, then run `/mcp auth sup-dropshipping`:

```json
{
  "mcpServers": {
    "sup-dropshipping": {
      "httpUrl": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Claude, ChatGPT and other chat apps

Open the app's connector (or custom app) settings, add a custom connector, and paste the URL. Leave any client ID and secret fields empty: the app registers itself. Availability depends on the app and your plan.

## The approval page

The page shows:

- **App (as it names itself)**: the name the AI tool gave when it registered. Only continue if it is the tool you are connecting.
- **You will be sent back to**: where the browser goes after you click. A local tool shows "an app on this computer".
- **Signed in as**: the SUP Dropshipping account the tool will read. Sign out and back in on the website first if it is the wrong account.

Each approval is a separate connection. You can connect several tools and computers to the same account.

## Staying signed in

- The tool gets a one-hour access token and refreshes it on its own. A connection that is used at least once every 60 days stays signed in.
- If a tool says it needs to sign in again, run its authenticate or login step again (for Claude Code: `/mcp`, then **Authenticate**).
- To disconnect a tool, remove the server in that tool. The tool can also revoke its token on the way out.

## Troubleshooting

| What you see | What to do |
| --- | --- |
| The browser shows the login page | Sign in. You are sent back to the approval page. |
| "Unknown application" or "unregistered redirect address" | Remove the server from the tool, add it again, and retry. |
| "Your sign-in expired" or "This page is out of date" | Start again from the tool. The page is valid only for the request that opened it. |
| The tool keeps asking you to sign in | Check that the tool can open a browser on this computer, and that the computer's clock is correct. |
| `Rate limit reached` | Wait a minute. The limit is 60 tool calls per minute per connection. |
| `401` with the skills' access key | The key was replaced or removed. Connect again with the skills' `login` command, or use browser sign-in instead. |

Advanced: the server also accepts the skills' access key (`supak_...`) as a bearer token, for tools that only support a fixed `Authorization` header. Browser sign-in is preferred.
