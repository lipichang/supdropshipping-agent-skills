---
name: sup-dropshipping-inventory
description: "List the user's private inventory held in SUP Dropshipping warehouses from the read-only AI API: stock on hand per SKU, total units stocked, variant, and warehouse. Use when the user wants to check their own pre-purchased stock, find items that are out of stock or running low, or look up stock for a SKU, rather than inspect connected products, orders, wallet history, invoices, or sourcing requests."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Inventory

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks how much stock they have in SUP's warehouse
- The user asks which of their stocked items are out of stock or low
- The user looks up private stock by product title or SKU

## Do Not Use This Skill When

- The user asks about SUP's general supplier stock for a catalog product
  The AI API does not expose it.
- The user wants the store-product mapping
  Use `sup-dropshipping-products`.
- The user wants to buy or move inventory
  The AI API is read-only.

## Core Concept Mapping

- "My inventory" / "private inventory" / "pre-stocked goods" means units the user already purchased and SUP stores for them.
- "In stock" maps to `in_stock=1`, "out of stock" to `in_stock=0`.
- "Low stock" has no server filter. List `in_stock=1` rows and compare `stock` with the threshold the user gives. Ask for a threshold if none was given.

## Preferred Path

- Use `GET /api/ai/v1/inventory`

## Read Next

- `references/inventory-list.md`

## Troubleshooting

- For account or integration issues, the user should contact their SUP Dropshipping agent.
