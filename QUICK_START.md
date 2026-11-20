# SUP Dropshipping AI Quick Start

This guide gets a local AI tool talking to your SUP Dropshipping account through the read-only AI API.

## 1. What You Need

- A SUP Dropshipping account
- A supported AI tool installed on your computer (for example Claude Code or Codex)
- macOS/Linux: `sh`, `curl` (or `wget` for the installer), and `unzip`
- Windows: Windows PowerShell 5.1 or PowerShell 7

You do not need `git` or `npm`.

## 2. Install The Skills

macOS/Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

If you downloaded the package instead, run `sh install.sh`, or on Windows `install.cmd`, from the unpacked folder.

The installer finds the AI tools on your machine and installs the SUP Dropshipping skills into each of them. Your other skills are left alone.

Restart your AI tool afterwards so it loads the new skills.

## 3. Connect Your Account

Ask your AI tool:

```text
Connect to my SUP Dropshipping account.
```

1. A page on supdropshipping.com opens in your browser. If it does not, the AI tool shows you the link.
2. Sign in with your usual SUP Dropshipping account if asked.
3. Check that the code on the page matches the code in your AI tool, then click **Allow**.

That is all. Your AI tool saves the connection on this computer and reuses it next time:

- macOS/Linux: `~/.config/sup-dropshipping/ai-api.json`
- Windows: `%USERPROFILE%\.sup-dropshipping\ai-api.json`

You never need to copy a key or type your password into the AI tool.

Good to know:

- The connection is read-only. It cannot pay, cancel, or change anything.
- Each account has one AI connection. Connecting a second computer disconnects the first one; just connect again on whichever computer you use.

## 4. First Question

```text
Show me my SUP Dropshipping account summary.
```

For a full walkthrough with more examples, see [USER_GUIDE.md](./USER_GUIDE.md).

## 5. Example Prompts

### Account summary

```text
Show me my SUP Dropshipping account summary: balance, available credit, and how many orders are in each status.
```

### Orders waiting for payment

```text
List my orders that are awaiting payment, with store order number, buyer country, and total cost.
```

### Where is my order

```text
Find the order with store order number #1001 and tell me its status and tracking number.
```

### Spending this month

```text
How much did I pay SUP this month? Use my wallet history and list refunds separately.
```

### SKU mapping

```text
Show the connected products for my store "My Store" and how each store variant maps to a SUP SKU.
```

### Stock check

```text
Which items in my private inventory have fewer than 20 units left?
```

### Sourcing requests

```text
Which of my sourcing requests are still pending, and what did SUP reply to the ones that are done?
```

## 6. Troubleshooting

### 401 Unauthorized

The connection on this computer was replaced (you connected another computer) or removed. Ask your AI tool to connect to SUP Dropshipping again.

### The sign-in page says "Code not found" or "expired"

Codes are valid for 10 minutes and can be used once. Ask your AI tool to connect again to get a new code.

### 422 Invalid Request

A filter value is not accepted, for example a date that is not `YYYY-MM-DD` or a `per_page` above 100. Ask the AI tool to retry with a simpler request.

### 429 Rate Limit Exceeded

Too many requests in one minute. Wait a minute and try again.

### "The AI API is read-only"

The skills can read your data but cannot pay, cancel, or change anything. Do those actions in the SUP Dropshipping website.

### No Tools Detected

The installer only installs into AI tools it finds on your machine. Install the AI tool first, start it once, then run the installer again.
