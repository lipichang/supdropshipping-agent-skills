---
name: sup-dropshipping-orders
description: "List, filter, and inspect store orders from the SUP Dropshipping read-only AI API, including order status, product cost, shipping cost, total cost, buyer, shipping address, line items, shipping method, and tracking numbers. Use when the user wants to review orders, check what an order costs, find orders by status, store, date, buyer, or tracking number, or look up the shipment of one order, rather than inspect connected products, inventory, wallet history, invoices, or sourcing requests."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping Orders

> Read [`../sup-dropshipping-ai-shared/SKILL.md`](../sup-dropshipping-ai-shared/SKILL.md) first.

## Use This Skill When

- The user asks for their orders or for orders in a given status
- The user asks what an order costs (product cost, shipping cost, total)
- The user asks for orders by store, date range, buyer, order number, or tracking number
- The user asks where an order is, or for its tracking number

## Do Not Use This Skill When

- The user only wants order counts by status
  Use `sup-dropshipping-dashboard`.
- The user wants payments and refunds as wallet movements
  Use `sup-dropshipping-billing-logs`.
- The user wants the store-product to SUP-product mapping
  Use `sup-dropshipping-products`.
- The user wants to pay, cancel, edit, or place orders
  The AI API is read-only.

## Core Concept Mapping

- "Store order number" (for example a Shopify `#1001`) maps to `store_order_number`. "SUP order number" maps to `order_number`.
- "Product cost" maps to `product_cost`, "shipping cost" to `shipping_cost`, "total cost" to `total_cost`. All are what SUP charges, in USD.
- `items[].store_price` is the selling price in the user's store, not a SUP cost.
- "Unpaid orders" map to `status=awaiting_payment`. "Orders not placed yet" map to `status=to_order`.
- "Shipped orders" map to `status=fulfilled,completed`.
- "In progress" maps to `status=pending,processing`.

## Preferred Path

- Use `GET /api/ai/v1/orders` to list and filter.
- Use `GET /api/ai/v1/orders/{id}` for one order's full address, shipments, and per-item tracking. The `id` is the `id` field from the list, not the order number.

## Read Next

- `references/orders-list.md`
- `references/order-detail.md`

## Workflow Notes

- To find an order by number, filter the list with `order_number` or `store_order_number` (exact match), then call the detail endpoint with the returned `id`.
- When the user names a store, resolve its `store_id` with `GET /api/ai/v1/stores` first.
- To total costs over a period, page through the filtered list and sum `total_cost`. Say which statuses and dates were included.
- For `to_order` and `awaiting_payment` orders the cost fields may be zero or not final. Costs are final once the order is paid.

## Troubleshooting

- For account or integration issues, the user should contact their SUP Dropshipping agent.
