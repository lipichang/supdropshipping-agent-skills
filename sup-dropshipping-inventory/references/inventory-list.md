# Inventory List Endpoint

## Endpoint

```text
GET /api/ai/v1/inventory
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/inventory --param page=1 --param per_page=50 --param in_stock=1
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/inventory --param page=1 --param per_page=50 --param in_stock=1
```

## Supported Query Parameters

- `keyword`: part of the product title, or an exact SKU
- `in_stock`: `1` for rows with stock, `0` for rows without stock
- `page`, `per_page`

Any other `in_stock` value returns `422` with `code=invalid_in_stock`.

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 301,
      "sup_product_id": 88001,
      "sup_variant_id": 990012,
      "title": "Unisex Fleece Hoodie",
      "sku": "SUP88001-BLK-M",
      "variant": "Black;M",
      "stock": 120,
      "total_stocked": 300,
      "warehouse": { "id": 1, "name": "China Warehouse" },
      "image": "https://...",
      "created_at": "2026-08-15 11:02:45"
    }
  ]
}
```

## Field Semantics

- `stock`: units currently on hand for the user
- `total_stocked`: cumulative units purchased into this row, including units already shipped out
- `sup_product_id`: matches `sup_product.id` in the products skill
- `sup_variant_id`: SUP variant id; `null` for single-variant products
- `warehouse`: where the units are stored
- `created_at`: when the row was first stocked

## Notes

- Rows are sorted by `stock`, highest first.
- One row is one SKU in one warehouse. The same SKU can appear once per warehouse.
