# Errors And Retries

## Response Shape

Errors are JSON with the real HTTP status:

```json
{
  "error": "human-readable message",
  "status": 422,
  "code": "stable_machine_code"
}
```

`Retry-After` is also present on rate-limit responses.

## Common Error Codes

- `unauthorized` (401)
- `resource_not_found` (404)
- `method_not_allowed` (405)
- `invalid_request` (422): a malformed `page`, `store_id`, or similar value
- `invalid_per_page` (422)
- `invalid_date` (422)
- `rate_limit_exceeded` (429)

Resource-specific validation codes:

- Orders: `invalid_status`
- Inventory: `invalid_in_stock`
- Billing logs: `invalid_type`
- Sourcing requests: `invalid_status`

## Retry Policy

- `401`: do not retry; run browser sign-in again
- `404`: do not retry; check the id with the list endpoint
- `422`: do not retry without changing the request
- `429`: wait `Retry-After` seconds, then retry once
- `5xx` or network error: stop and report the failure
