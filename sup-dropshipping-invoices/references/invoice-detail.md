# Invoice Detail Endpoint

## Endpoint

```text
GET /api/ai/v1/invoices/{id}
```

`{id}` is the numeric `id` from the invoice list. It is not the invoice number.

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/invoices/4101
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/invoices/4101
```

## Response

The response is one object with every field of a list row (see `invoices-list.md`), plus:

- `note`: free-text note on the invoice
- `customer`: `name`, `company`, `address`, `address2`, `phone`, `email`
- `issuer`: `name`, `address`, `city`, `country`, `zip_code`, `phone`, `email`, `tax_number`
- `items`: one entry per invoice line
  - `name`
  - `quantity`
  - `unit_price`
  - `tax`
  - `discount`
  - `total_price`

## Notes

- `customer` and `issuer` are `null` when the invoice has none recorded.
- An id that does not belong to the account returns `404` with `code=resource_not_found`.
- Customer contact fields are personal data. Show them only when the user asks.
