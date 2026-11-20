---
name: sup-dropshipping-invoices
description: "List and inspect invoices from the SUP Dropshipping read-only AI API: the invoices the user generated from their orders, with invoice number, date, status, goods amount, shipping fee, tax, total, customer, issuer, and line items. Use when the user wants to find an invoice, review invoice totals for a period, or read the lines of one invoice, rather than see wallet transactions, order costs, or the account balance."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Invoices

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks for their invoices or for one invoice by number
- The user asks for invoices in a date range or for one customer
- The user asks for the lines, tax, or totals of an invoice

## Do Not Use This Skill When

- The user wants what SUP charged their wallet
  Use `sup-dropshipping-billing-logs`.
- The user wants order costs and tracking
  Use `sup-dropshipping-orders`.
- The user wants to create, edit, or finalise an invoice
  The AI API is read-only.

## Core Concept Mapping

- An invoice here is a document the user generated in SUP Dropshipping from one of their orders. It exists only for orders where the user created one.
- "Customer" is the party the invoice is addressed to. "Issuer" is the company details printed as the sender.
- Invoice amounts are the values written on the invoice document. They are not wallet movements.

## Preferred Path

- Use `GET /api/ai/v1/invoices` to list and filter.
- Use `GET /api/ai/v1/invoices/{id}` for one invoice with customer, issuer, and line items. The `id` is the `id` field from the list, not the invoice number.

## Read Next

- `references/invoices-list.md`
- `references/invoice-detail.md`

## Troubleshooting

- For account or integration issues, the user should contact their SUP Dropshipping agent.
