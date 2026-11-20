---
name: sup-dropshipping-products
description: "List and search connected products from the SUP Dropshipping read-only AI API: which store products are linked to which SUP products, with the variant-level mapping, SKUs, store prices, and SUP list prices. Use when the user wants to review connected products, check how a store variant maps to a SUP SKU, find a connected product by title or SKU, or compare store price with SUP list price, rather than inspect orders, private inventory, wallet history, invoices, or sourcing requests."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Products

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks which of their store products are connected to SUP
- The user asks which SUP product or SKU fulfills a store product or variant
- The user searches connected products by title or SKU
- The user wants connected products for one store

## Do Not Use This Skill When

- The user wants stock they own in a SUP warehouse
  Use `sup-dropshipping-inventory`.
- The user wants what an order actually cost
  Use `sup-dropshipping-orders`.
- The user wants a product SUP has not sourced yet
  Use `sup-dropshipping-sourcing`.
- The user wants to connect, disconnect, or edit products
  The AI API is read-only.

## Core Concept Mapping

- "Connected product" is one link between a store product and a SUP product. One row per link.
- "Store product" is the listing in the user's sales channel. "SUP product" is the item SUP ships.
- "SKU mapping" maps to the `variants` array of a row.
- `sup_list_price` is SUP's list price before membership-level pricing and without shipping. It is not the final charge. For real charged amounts use the orders skill.

## Preferred Path

- Use `GET /api/ai/v1/products`

## Read Next

- `references/products-list.md`

## Troubleshooting

- For account or integration issues, the user should contact their SUP Dropshipping agent.
