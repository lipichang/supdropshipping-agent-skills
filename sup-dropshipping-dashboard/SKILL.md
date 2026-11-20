---
name: sup-dropshipping-dashboard
description: "Get the SUP Dropshipping account summary from the read-only AI API: wallet balance, credit limit and credit used, number of connected stores, order counts by status, and sourcing request counts, plus the list of connected stores with their ids. Use when the user wants a quick account or wallet overview, wants to know how many orders are waiting, or needs a store id for another query, rather than detailed order, product, inventory, billing, invoice, or sourcing rows."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Dashboard

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks for their current balance or available credit
- The user asks how many orders are awaiting payment, processing, fulfilled, and so on
- The user asks how many sourcing requests are pending
- The user asks which stores are connected, or another skill needs a `store_id`
- Credentials need a validation probe in a new session

## Do Not Use This Skill When

- The user wants the underlying order rows
  Use `sup-dropshipping-orders`.
- The user wants wallet transaction history
  Use `sup-dropshipping-billing-logs`.
- The user wants sourcing request details
  Use `sup-dropshipping-sourcing`.

## Core Concept Mapping

- "Balance" means the wallet balance in USD.
- "Available credit" is `credit_available` (`credit_limit` minus `credit_used`). A `credit_limit` of `0` means credit is not enabled for the account.
- "Orders to place" / "unprocessed store orders" map to `order_counts.to_order`.
- "Unpaid orders" map to `order_counts.awaiting_payment`.

## Preferred Path

- Use `GET /api/ai/v1/dashboard` for the summary.
- Use `GET /api/ai/v1/stores` for the store list.

## Read Next

- `references/dashboard-summary.md`
- `references/stores-list.md`

## Troubleshooting

- For account or integration issues, the user should contact their SUP Dropshipping agent.
