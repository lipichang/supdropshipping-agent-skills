# Connect SUP Dropshipping as an MCP Server

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

SUP Dropshipping also runs a remote MCP server. Any AI tool that supports remote MCP servers can connect to it directly, without installing the skills. You sign in with your SUP Dropshipping account in the browser; there is no key to copy.

```
https://www.supdropshipping.com/mcp
```

| | Skills (this repository) | MCP server |
| --- | --- | --- |
| Install | Run the installer once per computer | Add one URL in your AI tool |
| Sign in | `login` command, browser approval | Browser approval when the tool first connects |
| Works in | Tools that load agent skills (Claude Code, Codex, Cursor, ...) | Any tool with remote MCP support: Claude, ChatGPT, Cursor, VS Code, Windsurf, Zed, Cline, Kiro, OpenCode, Gemini CLI, ... |
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

### Claude (web, desktop and mobile)

Add a custom connector in Claude's connector settings (Customize → Connectors → Add custom connector). Name it `SUP Dropshipping`, paste the URL, leave the client ID and secret empty, then click **Connect** and approve. A connector added once is available in Claude on the web, the desktop app, the mobile apps and Cowork.

### ChatGPT

1. In ChatGPT on the web, turn on **Developer mode** (Settings → Apps → Advanced settings).
2. Create an app, paste the URL, and set **Authentication** to **OAuth**. Leave the client ID and secret empty.
3. Sign in to SUP Dropshipping and click **Allow**.

Developer mode availability depends on your ChatGPT plan; read-only servers like this one work on more plans.

### Windsurf

Add this to `~/.codeium/windsurf/mcp_config.json` (note the key is `serverUrl`, not `url`), save, and click **Refresh** in the MCP panel. Windsurf opens the sign-in page:

```json
{
  "mcpServers": {
    "sup-dropshipping": {
      "serverUrl": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Zed

Open Settings → AI → MCP Servers, click **Add Server** → **Add Remote Server**, or add this to your Zed `settings.json` (Zed uses `context_servers`, not `mcpServers`):

```json
{
  "context_servers": {
    "sup-dropshipping": {
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Cline

In Cline, open **MCP Servers** → **Remote Servers**, enter the URL and choose Streamable HTTP, or add this to `cline_mcp_settings.json`. Set `"type": "streamableHttp"`; without it Cline uses the older SSE transport, which this server does not support.

```json
{
  "mcpServers": {
    "sup-dropshipping": {
      "type": "streamableHttp",
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Kiro

Add this to `~/.kiro/settings/mcp.json` (all workspaces) or `.kiro/settings/mcp.json` (one workspace). Kiro opens the sign-in page when it connects:

```json
{
  "mcpServers": {
    "sup-dropshipping": {
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### OpenCode

```bash
opencode mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp
opencode mcp auth sup-dropshipping
```

Or add it to `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "sup-dropshipping": {
      "type": "remote",
      "url": "https://www.supdropshipping.com/mcp"
    }
  }
}
```

### Other tools

Any tool that supports remote MCP servers over Streamable HTTP with OAuth works: add the URL and leave client ID and secret fields empty. The tool registers itself and opens the sign-in page.

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
