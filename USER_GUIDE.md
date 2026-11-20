# SUP Dropshipping AI Skills: User Guide

This guide walks you through using your AI tool with your SUP Dropshipping account, from connecting your account to asking everyday questions about orders, costs, and stock.

If you have not installed the skills yet, start with [QUICK_START.md](./QUICK_START.md), then come back here.

Using the MCP server instead of the skills? Follow [MCP_GUIDE.md](./MCP_GUIDE.md) to connect. Sections 4 to 7 of this guide (what to ask, walkthroughs, tips) apply to both.

## Contents

1. [Before you start](#1-before-you-start)
2. [Check the skills are installed](#2-check-the-skills-are-installed)
3. [Connect your account](#3-connect-your-account)
4. [Ask your first question](#4-ask-your-first-question)
5. [What you can ask](#5-what-you-can-ask)
6. [Walkthroughs](#6-walkthroughs)
7. [Tips for better answers](#7-tips-for-better-answers)
8. [Managing your connection](#8-managing-your-connection)
9. [Privacy and safety](#9-privacy-and-safety)
10. [Troubleshooting](#10-troubleshooting)

---

## 1. Before you start

You need:

- A SUP Dropshipping account you can sign in to at [www.supdropshipping.com](https://www.supdropshipping.com)
- An AI tool that runs on your computer, with the SUP Dropshipping skills installed. Claude Code and Codex are the main supported tools.
- A web browser on the same computer (or on your phone, see [Signing in from another device](#signing-in-from-another-device))

You do **not** need an API key, and you never type your SUP password into the AI tool.

## 2. Check the skills are installed

In **Claude Code**, type:

```text
/skills
```

Type `sup` to filter the list. You should see eight skills:

| Skill | What it covers |
| --- | --- |
| `sup-dropshipping-ai-shared` | Sign-in and connection rules used by all the others |
| `sup-dropshipping-dashboard` | Balance, credit, order counts, connected stores |
| `sup-dropshipping-orders` | Orders, costs, buyers, tracking |
| `sup-dropshipping-products` | Store products connected to SUP products, SKU mapping |
| `sup-dropshipping-inventory` | Your own stock held in SUP warehouses |
| `sup-dropshipping-billing-logs` | Wallet payments and refunds |
| `sup-dropshipping-invoices` | Invoices you created for your customers |
| `sup-dropshipping-sourcing` | Sourcing requests and SUP's replies |

Press `Esc` to close the list. Use only the arrow keys to move around it: pressing **Space** or **Enter** on a skill switches it off. If a skill shows as off, select it and press Space until it is on again, then press `Esc`.

In other tools, check that the `sup-dropshipping-*` folders exist in the tool's skills folder (see the table in [README.md](./README.md#tool-support)).

## 3. Connect your account

You do this once per computer.

### Step 1: Ask your AI tool to connect

```text
Connect to my SUP Dropshipping account.
```

The AI tool starts a sign-in and shows you a link and an 8-letter code, for example:

```text
To connect this computer to your SUP Dropshipping account:
  1. Open this link (sign in to SUP Dropshipping if asked):
     https://www.supdropshipping.com/ai/authorize?code=DPHM-QFTN
  2. Check that the page shows the code: DPHM-QFTN
  3. Click "Allow".
The link was opened in your browser.
Waiting for approval...
```

Usually the page opens in your browser by itself. If it does not, open the link yourself.

### Step 2: Sign in on the SUP Dropshipping website

If you are not signed in, the page sends you to the normal SUP Dropshipping login page first. After you sign in, you come back to the connection page automatically.

### Step 3: Check the code and click Allow

The page **Connect an AI tool to your account?** shows:

- The 8-letter code. **It must be the same code your AI tool showed.** If it is not, or you did not start a connection yourself, click **Deny**.
- What the AI tool will be able to do: read your balance, orders, connected products, inventory, wallet history, invoices and sourcing requests. It cannot pay, cancel, edit or place anything.
- The account you are signed in as, and the computer that asked.
- A note if you already have an AI connection, because a new one replaces it (see [section 8](#8-managing-your-connection)).

Click **Allow**. The page says **Connected** and you can close the tab.

### Step 4: Back in the AI tool

Within a few seconds the AI tool reports something like:

```text
Connected as you@example.com. Credentials saved to ~/.config/sup-dropshipping/ai-api.json
```

You are done. The connection is saved on this computer and reused in every new session.

> If you were slower than about a minute and a half, the AI tool may say it is still waiting. Just tell it "I clicked Allow" and it picks up where it left off. The link stays valid for 10 minutes.

### Signing in from another device

If your AI tool runs on a machine without a browser (for example a remote server), ask:

```text
Connect to my SUP Dropshipping account without opening a browser.
```

Open the link it shows on your phone or laptop, sign in, check the code, and click Allow. The connection is saved on the machine running the AI tool.

## 4. Ask your first question

```text
Show me my SUP Dropshipping account summary.
```

You get your wallet balance, available credit, how many orders are in each status, and how many sourcing requests are pending. For example:

```text
Here's your SUP Dropshipping account summary:

- Wallet balance: $1,250.40
- Credit line: not enabled
- Orders: 4 waiting to be placed, 1 awaiting payment, 12 processing, 40 shipped, 310 completed
- Sourcing requests: 1 pending, 9 answered
```

You can ask in English or in your own language. The AI tool answers in the language you use.

## 5. What you can ask

You do not need special commands. Ask the way you would ask a colleague. Some examples:

| You want to know | Try asking |
| --- | --- |
| Balance and order counts | "What's my SUP balance and how many orders are unpaid?" |
| Connected stores | "Which stores are connected to SUP?" |
| Recent orders | "List my last 20 orders with store order number, status and total cost." |
| Orders in a status | "Which orders are awaiting payment?" |
| One order | "What's the status and tracking number of store order #1279?" |
| Costs over a period | "What did my October orders cost in products and shipping?" |
| Orders for one buyer or country | "Show orders shipped to Canada this month." |
| SKU mapping | "Which SUP SKU fulfills each variant of my hoodie listing?" |
| Store price vs SUP price | "Compare my store prices with SUP list prices for connected products." |
| Stock | "Which items in my SUP inventory have fewer than 20 units?" |
| Payments and refunds | "How much did I pay SUP this month? List refunds separately." |
| One payment | "What was charged for order S2026110112345?" |
| Invoices | "Show invoice INV-000123 with its line items." |
| Sourcing | "Which sourcing requests are still pending, and what did SUP reply to the others?" |

If you want to be sure a specific skill is used in Claude Code, start your message with its name, for example:

```text
/sup-dropshipping-orders orders shipped last week
```

## 6. Walkthroughs

### A. Morning check

```text
Give me a quick SUP check: balance, orders waiting for payment, and anything still processing for more than 7 days.
```

The AI tool reads your summary, then lists the matching orders. Follow up with:

```text
Show the details of the oldest one.
```

### B. A customer asks "where is my order?"

```text
My customer says order #1458 hasn't arrived. What's its status and tracking number?
```

The AI tool finds the order by your store order number and shows its status, shipping method, tracking number per package, and when each package shipped. Buyer contact details are only shown if you ask for them.

### C. Month-end reconciliation

```text
For October 2026, list every SUP payment and refund, then total them.
```

Then:

```text
Group the payments by store order and save it as a CSV file on my desktop.
```

Good to know: one SUP payment can cover several orders paid together. The AI tool shows which orders each payment covered. For one order's own product and shipping cost, ask about the order itself.

### D. Restock planning

```text
Which of my pre-stocked items have less than 30 units left? Include the SKU and warehouse.
```

Then:

```text
Which of my connected store products use those SKUs?
```

The AI tool matches the SKUs in your inventory with the SUP SKUs of your connected products, so you can see which listings are about to run short.

### E. Following up on sourcing

```text
What did SUP reply to my sourcing requests from the last two weeks?
```

The AI tool summarizes each reply and keeps any prices and quantities exactly as SUP wrote them.

## 7. Tips for better answers

- **Give a time range** ("this month", "since November 1", "last 30 days"). Results come back faster and more precisely.
- **Name the status** ("unpaid", "shipped", "processing") when you know it.
- **Use the order number your customer sees** (your store order number, like `#1458`) or SUP's order number. Both work.
- **Keep going in the same conversation.** "Only the ones to the US", "sort by cost", "make it a table" refine the last answer.
- **Ask for files.** Your AI tool can save results as CSV or a spreadsheet on your computer.
- **Amounts are in US dollars** unless the answer says otherwise.
- **Large lists take longer.** If you have thousands of orders, narrow the question first.

## 8. Managing your connection

**Where it is saved.** On the computer running the AI tool:

- macOS/Linux: `~/.config/sup-dropshipping/ai-api.json`
- Windows: `%USERPROFILE%\.sup-dropshipping\ai-api.json`

Treat this file like a password. Do not share it or put it in a code repository.

**One connection per account.** Each SUP Dropshipping account has one AI connection at a time. If you connect a second computer, the first one is disconnected and will be asked to sign in again the next time it is used. Just connect again on whichever computer you are using.

**Reconnect.** Ask your AI tool "Connect to my SUP Dropshipping account" again at any time. The new connection replaces the old one.

**Disconnect this computer.** Delete the file above. If you think someone else may have a copy of it, ask your SUP Dropshipping agent to revoke your AI connection, or connect again from your own computer, which makes the old one stop working.

## 9. Privacy and safety

- **Read-only.** The AI connection can only read data. It cannot pay, cancel, edit, connect products, or place orders. Do those in the SUP Dropshipping website.
- **Your password stays on the website.** You sign in only on supdropshipping.com. The AI tool never asks for your password, and you should never give it.
- **Check the code.** Only click Allow when the code on the page matches the code in your AI tool and you started the connection yourself.
- **What the AI tool sees.** Results you ask for are shown to your AI tool, and through it to its model provider, like anything else you discuss with it. Buyer names, addresses and phone numbers are only shown when you ask for them.

## 10. Troubleshooting

| What you see | What to do |
| --- | --- |
| The AI tool does not seem to know about SUP Dropshipping | Check the skills are installed and switched on (section 2), then start a new session. |
| `Skill "sup-dropshipping-..." is disabled` | In Claude Code, open `/skills`, select the skill, press Space until it is on, then `Esc`. |
| The browser did not open | Open the link the AI tool shows you. |
| The page says **Code not found** or **expired** | Codes last 10 minutes and work once. Ask the AI tool to connect again. |
| The page shows a different code from your AI tool | Click **Deny**. Ask the AI tool to connect again. |
| The AI tool says it is still waiting after you clicked Allow | Tell it "I clicked Allow". It checks again. |
| `401 Unauthorized` or "connection was replaced" | You connected another computer, or the connection was revoked. Connect again. |
| `429` or "rate limit" | You asked a lot in a short time. Wait a minute and try again. |
| "The AI API is read-only" | You asked for a change. Do it in the SUP Dropshipping website. |
| Something else | Contact your SUP Dropshipping agent. Mention the time and what you asked. |
