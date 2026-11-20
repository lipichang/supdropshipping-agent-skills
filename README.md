# SUP Dropshipping Agent Skills

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

Agent skills for the SUP Dropshipping read-only AI API.

Install this pack into a local AI coding tool (Claude Code, Codex, and others) and ask about your SUP Dropshipping account in plain language: orders, costs, tracking, connected products, private inventory, wallet history, invoices, and sourcing requests.

## Included Skills

- `sup-dropshipping-ai-shared`: auth, credentials, pagination, rate limits, errors, and the request helper
- `sup-dropshipping-dashboard`: account summary and connected stores
- `sup-dropshipping-orders`: store orders, costs, status, tracking
- `sup-dropshipping-products`: connected products and variant mapping
- `sup-dropshipping-inventory`: private inventory in SUP warehouses
- `sup-dropshipping-billing-logs`: wallet transaction history
- `sup-dropshipping-invoices`: invoices and invoice lines
- `sup-dropshipping-sourcing`: sourcing requests and replies

## What This Repository Provides

- A standalone multi-skill pack
- Installers for macOS, Linux, and Windows, with no `git` or `npm` requirement
- A helper script that keeps your secret out of prompts and shell output
- Read-only access: the API accepts `GET` requests only

## Quick Start

See [QUICK_START.md](./QUICK_START.md).

Short version: run the installer, restart your AI tool, ask it to "connect to my SUP Dropshipping account", click **Allow** in the browser, then ask your first question.

## MCP Server (no install)

Prefer not to install anything? Add `https://www.supdropshipping.com/mcp` as a remote MCP server in Claude, ChatGPT, Claude Code, Codex, Cursor, VS Code or Gemini CLI, and sign in in the browser. See [MCP_GUIDE.md](./MCP_GUIDE.md).

## User Guide

See [USER_GUIDE.md](./USER_GUIDE.md) for the full walkthrough: connecting your account, what you can ask, example conversations, managing the connection, and troubleshooting.

## One-Command Install

macOS/Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

From a downloaded or unpacked copy of this repository:

```sh
sh install.sh
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

```cmd
install.cmd
```

The installer detects supported AI tools under your user profile and copies every `sup-dropshipping-*` skill folder into each tool's skills directory. Existing copies are moved to `.supdropshipping-agent-skills-backups` next to the skills directory before they are replaced. Other skills are not touched.

## Options

| macOS/Linux | Windows | Effect |
| --- | --- | --- |
| `--dry-run` | `-DryRun` | Show detected tools and planned actions without changing files |
| `--ref REF` | `-Ref REF` | Install from a GitHub branch or tag (default `main`) |
| `--tool KEY` | `-Tool KEY` | Install only into the given tool; may be repeated |
| `--source-dir PATH` | `-SourceDir PATH` | Install from a local copy instead of GitHub |

Examples:

```sh
sh install.sh --dry-run
sh install.sh --tool claude_code --tool codex
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -DryRun
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Tool claude_code -Tool codex
```

## Tool Support

| Key | Tool | Skills directory |
| --- | --- | --- |
| `claude_code` | Claude Code | `~/.claude/skills` |
| `codex` | Codex | `~/.codex/skills` |
| `openclaw` | OpenClaw | `~/.openclaw/skills` |
| `cursor` | Cursor | `~/.cursor/skills` |
| `antigravity` | Antigravity | `~/.gemini/antigravity/skills` |
| `opencode` | OpenCode | `~/.config/opencode/skills` |
| `continue` | Continue | `~/.continue/skills` |
| `gemini_cli` | Gemini CLI | `~/.gemini/skills` |
| `github_copilot` | GitHub Copilot | `~/.copilot/skills` |
| `qwen_code` | Qwen Code | `~/.qwen/skills` |
| `windsurf` | Windsurf | `~/.codeium/windsurf/skills` |

Claude Code and Codex are the primary targets. The other tools are best effort: the installer copies the skills into the directory listed above when the tool's folder exists.

## API Surface

Base URL: `https://www.supdropshipping.com`

| Endpoint | Skill |
| --- | --- |
| `GET /api/ai/v1/dashboard` | dashboard |
| `GET /api/ai/v1/stores` | dashboard |
| `GET /api/ai/v1/orders` | orders |
| `GET /api/ai/v1/orders/{id}` | orders |
| `GET /api/ai/v1/products` | products |
| `GET /api/ai/v1/inventory` | inventory |
| `GET /api/ai/v1/billing-logs` | billing-logs |
| `GET /api/ai/v1/invoices` | invoices |
| `GET /api/ai/v1/invoices/{id}` | invoices |
| `GET /api/ai/v1/sourcing-requests` | sourcing |

Authentication: `Authorization: Bearer <access_key_id>.<secret>`. Customers get the credential through browser sign-in (`ai_api_request.sh login`), which uses `POST /api/ai/device/code`, the approval page `/ai/authorize`, and `POST /api/ai/device/token`.

## Security Notes

- The credential gives read access to your account data. Treat the saved config file like a password.
- Browser sign-in shows a code in both the AI tool and the browser. Only click Allow when they match and you started the sign-in yourself.
- Each account has one AI connection. A new sign-in invalidates the previous one immediately.
- Credentials are stored locally in `~/.config/sup-dropshipping/ai-api.json` (macOS/Linux) or `%USERPROFILE%\.sup-dropshipping\ai-api.json` (Windows). They are not sent anywhere except to the SUP Dropshipping API.
- The skills never ask for your account password.
