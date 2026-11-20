# Dashboard Summary Endpoint

## Endpoint

```text
GET /api/ai/v1/dashboard
```

No parameters.

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/dashboard
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/dashboard
```

## Response Shape

```json
{
  "currency": "USD",
  "balance": "123.45",
  "credit_limit": "500",
  "credit_used": "120.5",
  "credit_available": "379.5",
  "store_count": 2,
  "order_counts": {
    "to_order": 4,
    "awaiting_payment": 1,
    "pending": 3,
    "processing": 12,
    "fulfilled": 40,
    "completed": 310,
    "closed": 2,
    "refunded": 5,
    "invalid": 0,
    "trash": 7
  },
  "sourcing_counts": {
    "pending": 1,
    "failed": 0,
    "success": 9,
    "closed": 0
  }
}
```

## Field Semantics

- `balance`: wallet balance
- `credit_limit`: credit line granted by SUP; `0` means credit is not enabled
- `credit_used`: credit currently owed
- `credit_available`: `credit_limit - credit_used`, never below zero
- `store_count`: active connected stores
- `order_counts`: number of store orders in each status. `processing` includes partially fulfilled orders. See the orders skill for status meanings.
- `sourcing_counts`: number of sourcing requests in each status

Money values are strings in USD.

## Notes

- This is the cheapest endpoint. Use it as the validation probe in a new session.
- Counts cover all time, not a date range. For counts in a date range, query the orders list with a status and date filter and read `total_count`.
