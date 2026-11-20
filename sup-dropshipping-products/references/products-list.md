# Connected Products List Endpoint

## Endpoint

```text
GET /api/ai/v1/products
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/products --param page=1 --param per_page=50 --param keyword=hoodie
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/products --param page=1 --param per_page=50 --param keyword=hoodie
```

## Supported Query Parameters

- `keyword`: part of the SUP product title or SUP product SKU
- `store_id`: integer id from `GET /api/ai/v1/stores`
- `page`, `per_page`

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 501,
      "store": { "id": 1024, "name": "My Store" },
      "store_product": {
        "id": "7700000000001",
        "title": "Example Hoodie",
        "price": "39.99",
        "image": "https://..."
      },
      "sup_product": {
        "id": 88001,
        "title": "Unisex Fleece Hoodie",
        "sku": "SUP88001",
        "list_price": "11.5",
        "weight": 450,
        "image": "https://...",
        "url": "https://www.supdropshipping.com/p/..."
      },
      "variant_count": 1,
      "variants": [
        {
          "store_variant_id": "4400000000001",
          "store_sku": "HD-BLK-M",
          "store_price": "39.99",
          "sup_sku": "SUP88001-BLK-M",
          "sup_variant": "Black;M",
          "sup_list_price": "11.5",
          "sup_weight": 450
        }
      ],
      "connected_at": "2026-10-02 14:20:11"
    }
  ]
}
```

## Field Semantics

- `id`: id of the connection
- `store_product.id`: product id in the sales channel
- `store_product.price`, `variants[].store_price`: selling price as synced from the store
- `sup_product.sku`: SUP product code
- `sup_product.list_price`, `variants[].sup_list_price`: SUP list price in USD, before membership-level pricing, without shipping
- `sup_product.url`: product page on the SUP website
- `variants[].store_variant_id`: variant id in the sales channel
- `variants[].sup_sku`: SUP variant SKU; falls back to the product SKU for single-variant products
- `variants[].sup_variant`: SUP variant option text
- `sup_weight`, `weight`: weight as stored by SUP

## Notes

- Rows are sorted newest connection first.
- `store_product.title`, `price`, and `image`, and `variants[].store_sku` / `store_price`, are `null` when the store listing is no longer synced (for example the store was disconnected). `store_variant_id` and the SUP side are still filled.
- A `keyword` search matches the SUP product side, not the store listing title.
- Do not present `sup_list_price` as the amount the user pays. Final cost depends on membership level, quantity, destination, and shipping method.
