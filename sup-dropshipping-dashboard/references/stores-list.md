# Stores List Endpoint

## Endpoint

```text
GET /api/ai/v1/stores
```

No parameters. Not paginated.

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/stores
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/stores
```

## Response Shape

```json
{
  "total_count": 1,
  "data": [
    {
      "id": 1024,
      "name": "My Store",
      "domain": "my-store.myshopify.com",
      "platform_type": 1,
      "country": "US"
    }
  ]
}
```

## Field Semantics

- `id`: the `store_id` accepted by the orders and products list filters
- `name`: store display name
- `domain`: store domain or shop identifier
- `platform_type`: sales-channel code. `1` is Shopify; other numbers are other channels. Do not guess the channel name for other codes.
- `country`: store country, when set

## Notes

- Only active stores are returned.
- When the user names a store, resolve it to an `id` here before filtering orders or products.
