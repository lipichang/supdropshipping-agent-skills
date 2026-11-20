# Invoice List Endpoint

## Endpoint

```text
GET /api/ai/v1/invoices
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/invoices --param page=1 --param per_page=50
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/invoices --param page=1 --param per_page=50
```

## Supported Query Parameters

- `invoice_number`: exact match
- `status`: exact match against the invoice status text, for example `Finalised`
- `order_number`: exact match against the SUP order number or the store order number
- `customer_name`: part of the customer name
- `start_date`, `end_date`: filter on `invoice_date`
- `page`, `per_page`

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 4101,
      "invoice_number": "INV-000123",
      "invoice_date": "2026-11-02",
      "status": "Finalised",
      "order_number": "S2026110112345",
      "store_order_number": "#1001",
      "goods_amount": "12.4",
      "shipping_fee": "6.8",
      "tax_amount": "0",
      "total_amount": "19.2",
      "customer_name": "Jane Doe"
    }
  ]
}
```

## Field Semantics

- `id`: use this for the detail endpoint
- `status`: status text as stored. `Finalised` marks a finalised invoice.
- `goods_amount`, `shipping_fee`, `tax_amount`, `total_amount`: amounts printed on the invoice
- `customer_name`: who the invoice is addressed to

## Notes

- Rows are sorted newest first.
- The `status` filter is case-sensitive text. If unsure of the stored values, list without the filter and read `status` from the rows.
