# Order List Endpoint

## Endpoint

```text
GET /api/ai/v1/orders
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/orders --param page=1 --param per_page=50 --param status=processing
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/orders --param page=1 --param per_page=50 --param status=processing
```

## Supported Query Parameters

- `status`: one value or several separated by commas
- `store_id`: integer id from `GET /api/ai/v1/stores`
- `order_number`: SUP order number, exact match
- `store_order_number`: order number in the store, exact match
- `tracking_number`: exact match
- `buyer`: part of the recipient name
- `start_date`, `end_date`: filter on `store_order_time`
- `paid_start_date`, `paid_end_date`: filter on `paid_at`
- `page`, `per_page`

## Accepted Values

`status`:

- `to_order`: synced from the store, not yet placed with SUP
- `awaiting_payment`: placed, waiting for payment
- `pending`: paid, waiting for SUP to start processing
- `processing`: being processed; also matches partially fulfilled orders
- `partially_fulfilled`: some packages shipped
- `fulfilled`: shipped
- `completed`: delivered or finished
- `closed`
- `refunded`
- `invalid`
- `trash`: moved to trash by the user

When `status` is omitted, every status except `trash` is returned.

An unknown value returns `422` with `code=invalid_status`.

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 9001,
      "order_number": "S2026110112345",
      "store_order_number": "#1001",
      "store": { "id": 1024, "name": "My Store" },
      "status": "processing",
      "status_code": 2,
      "fulfilled_by_sup": true,
      "store_order_time": "2026-11-01 09:12:33",
      "created_at": "2026-11-01 09:15:02",
      "paid_at": "2026-11-01 10:00:41",
      "completed_at": null,
      "quantity": 2,
      "cost_currency": "USD",
      "product_cost": "12.4",
      "shipping_cost": "6.8",
      "remote_area_fee": "0",
      "total_cost": "19.2",
      "shipping_method": "SUP Standard",
      "tracking_number": null,
      "buyer": "Jane Doe",
      "shipping_address": { "city": "Austin", "province": "Texas", "country": "United States", "zip": "73301" },
      "items": [
        {
          "store_product_id": "7700000000001",
          "store_variant_id": "4400000000001",
          "title": "Example Product",
          "variant": "Black / M",
          "sku": "EX-BLK-M",
          "quantity": 2,
          "store_price": "29.99",
          "image": "https://..."
        }
      ]
    }
  ]
}
```

## Field Semantics

- `id`: use this for the detail endpoint
- `order_number`: SUP order number
- `store_order_number`: order number in the user's store
- `store`: `name` falls back to the store name recorded on the order when the store has since been disconnected
- `fulfilled_by_sup`: `false` when the user marked the order as fulfilled by themselves
- `store_order_time`: when the order was created in the store
- `created_at`: when the order reached SUP
- `quantity`: total units in the order
- `product_cost`: SUP product cost for the order
- `shipping_cost`: SUP shipping cost
- `remote_area_fee`: remote-area surcharge, when it applies
- `total_cost`: total amount SUP charges for the order
- `tracking_number`: main tracking number once shipped, otherwise `null`
- `items[].store_price`: the item's selling price as synced from the store
- `items[].variant`: variant option text

## Notes

- Rows are sorted by `store_order_time`, newest first.
- The list omits street address and phone. Use the detail endpoint when the user needs them.
- Cost fields are strings in USD. Convert to numbers before summing.
