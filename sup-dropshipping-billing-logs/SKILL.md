---
name: sup-dropshipping-billing-logs
description: "List wallet transaction history from the SUP Dropshipping read-only AI API: order payments, refunds, balance returns, and other wallet movements, with amount, related order numbers, and remark. Use when the user wants to review what was charged or refunded, reconcile spending over a period, or find the transaction for an order, rather than see the current balance, order details, or invoices."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Billing Logs

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks for their payment or refund history
- The user asks what was charged for a given order number
- The user wants spending or refunds over a date range

## Do Not Use This Skill When

- The user only wants the current balance or credit
  Use `sup-dropshipping-dashboard`.
- The user wants the cost breakdown of an order
  Use `sup-dropshipping-orders`.
- The user wants invoices issued to their own customers
  Use `sup-dropshipping-invoices`.
- The user wants to top up or withdraw
  The AI API is read-only.

## Core Concept Mapping

- "Payments" / "charges" map to `type=payment`.
- "Refunds" map to two types: `order_refund` and `balance_refund`. Query both and report them separately.
- "What was charged for order X" maps to `order_number=X`. A batch payment covers several orders, so its `amount` is for all orders in `orders`, not for X alone. For one order's own cost use `sup-dropshipping-orders`.
- Rows whose `type` is `other` are movements this API does not classify. Describe them with their `remark`; do not guess a category.

## Preferred Path

- Use `GET /api/ai/v1/billing-logs`

## Read Next

- `references/billing-logs-list.md`

## Troubleshooting

- For account or billing disputes, the user should contact their SUP Dropshipping agent.
