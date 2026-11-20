# Order Detail Endpoint

## Endpoint

```text
GET /api/ai/v1/orders/{id}
```

`{id}` is the numeric `id` from the order list. It is not the order number.

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/orders/9001
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/orders/9001
```

## Response

The response is one object with every field of a list row (see `orders-list.md`), plus:

- `shipping_address.address1`, `shipping_address.address2`, `shipping_address.phone`
- `shipments`: one entry per package label created for the order
  - `tracking_number`
  - `channel_code`: SUP's internal code for the logistics channel
  - `created_at`
- `fulfillment_items`: the SUP items fulfilled for the order
  - `title`, `variant`, `quantity`
  - `tracking_number`, `tracking_url`
  - `shipped_at`

## Notes

- An order split into several packages has several `shipments` and different tracking numbers across `fulfillment_items`.
- `shipments` and `fulfillment_items` are empty until the order is paid and processed.
- An id that does not belong to the account returns `404` with `code=resource_not_found`.
- The address and phone are the buyer's personal data. Show them only when the user asks.
