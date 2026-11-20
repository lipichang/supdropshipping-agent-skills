# Billing Logs List Endpoint

## Endpoint

```text
GET /api/ai/v1/billing-logs
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/billing-logs --param page=1 --param per_page=50 --param start_date=2026-11-01 --param end_date=2026-11-30
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/billing-logs --param page=1 --param per_page=50 --param start_date=2026-11-01 --param end_date=2026-11-30
```

## Supported Query Parameters

- `type`: one value, see below
- `order_number`: a SUP order number or store order number. Returns the transactions for that order, including a batch payment that covered it together with other orders. A `reference_number` or `transaction_number` from a previous response also works.
- `start_date`, `end_date`: filter on `created_at`
- `page`, `per_page`

## Accepted Values

`type`:

- `payment`: payment for an order or service
- `order_refund`: refund of an order payment
- `balance_refund`: wallet balance returned when an order is cancelled or closed
- `commission_transfer`: affiliate commission moved into the wallet
- a numeric `type_code` taken from a previous response

Anything else returns `422` with `code=invalid_type`.

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 70001,
      "transaction_number": "M2026110100001",
      "type": "payment",
      "type_code": 0,
      "payment_method_code": 1,
      "amount": "19.2",
      "balance_after": "690.14",
      "currency": "USD",
      "reference_number": "IV2026110110000001",
      "orders": [
        { "order_number": "S2026110112345", "store_order_number": "#1001" },
        { "order_number": "S2026110112346", "store_order_number": "#1002" }
      ],
      "remark": "Order paid",
      "created_at": "2026-11-01 10:00:41"
    }
  ]
}
```

## Field Semantics

- `transaction_number`: id of the wallet transaction
- `type`: one of the names above, or `other` when the code is not classified
- `type_code`: raw type code; pass it back as `type` to filter on an `other` category
- `payment_method_code`: raw payment-channel code; `0` is wallet balance. Do not name other channels from the code.
- `amount`: transaction amount in USD, as recorded. Use `type` to tell charges from refunds; do not rely on the sign.
- `balance_after`: wallet balance right after this transaction
- `reference_number`: what the transaction was for. It is often a batch payment number (starting with `IV`) rather than an order number.
- `orders`: the store orders this transaction paid or refunded. One batch payment can cover several orders. Empty when the transaction is not tied to store orders (for example a purchase order or a top-up).
- `remark`: description recorded with the transaction; may be in Chinese. A number at the end of a Chinese remark is the balance after the transaction, not the amount.

## Notes

- Rows are sorted newest first.
- To total spending, sum `amount` over `type=payment` rows. To total refunds, sum `order_refund` and `balance_refund` rows. Do not net them unless the user asks.
- A payment made by card or PayPal and a payment made from wallet balance both appear as `payment`; `payment_method_code` tells them apart only for `0` (balance).
