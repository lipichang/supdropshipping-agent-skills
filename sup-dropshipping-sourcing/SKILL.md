---
name: sup-dropshipping-sourcing
description: "List and search sourcing requests from the SUP Dropshipping read-only AI API: products the user asked SUP to source, with request number, title, source link, status, and SUP's reply. Use when the user wants to check whether a sourcing request was answered, review pending or failed requests, or read SUP's quote reply, rather than inspect already connected products, orders, inventory, wallet history, or invoices."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Sourcing Requests

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks for the status of their sourcing requests
- The user asks what SUP replied to a request
- The user searches a request by product title or request number

## Do Not Use This Skill When

- The user only wants the number of pending requests
  Use `sup-dropshipping-dashboard`.
- The user wants products that are already connected to a store
  Use `sup-dropshipping-products`.
- The user wants to submit or delete a sourcing request
  The AI API is read-only.

## Core Concept Mapping

- "Open" / "waiting for a quote" maps to `status=pending`.
- "Sourced" / "quoted" maps to `status=success`.
- "Could not be sourced" maps to `status=failed`.
- SUP's answer is the `reply` field. It is free text, may contain HTML, and usually holds the quote or the reason for failure. Quote from it; do not invent prices that are not in it.

## Preferred Path

- Use `GET /api/ai/v1/sourcing-requests`

## Read Next

- `references/sourcing-requests-list.md`

## Troubleshooting

- For questions about a quote, the user should contact their SUP Dropshipping agent.
