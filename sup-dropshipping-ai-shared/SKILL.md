---
name: sup-dropshipping-ai-shared
description: "Shared rules for the SUP Dropshipping read-only AI API: credential discovery from environment variables and local config files, safe credential persistence, Authorization header format, validation probe, pagination, date filters, rate-limit handling, error codes, and customer-data safety rules. Use when any sup-dropshipping skill needs global auth or execution rules before calling dashboard, stores, orders, products, inventory, billing logs, invoices, or sourcing requests."
metadata:
  author: sup-dropshipping
  version: "0.2.0"
---

# SUP Dropshipping AI Shared Rules

> Read this skill before using any `sup-dropshipping-*` domain skill.

## Shared Responsibilities

- Authentication and credential handling
- Base URL discovery
- Pagination and date defaults
- Rate-limit and retry behavior
- Stable error handling
- Customer-data handling boundaries

## Preconditions

- You need two credential values before calling the API: `access_key_id` and `secret`.
- The base URL defaults to `https://www.supdropshipping.com`. Only override it when the user gives a different one.
- Resolve credentials in this order:
  1. Environment variables
  2. Local config files
  3. Browser sign-in with the helper's `login` command (the normal way for a new user)
- Environment variables:
  - `SUP_AI_BASE_URL` (optional)
  - `SUP_AI_ACCESS_KEY_ID`
  - `SUP_AI_SECRET`
- Do not ask the user to paste a secret into the chat. Browser sign-in saves the credential locally without it passing through the conversation. Use pasted values only if the user already has them and offers them.
- The installed shared helper (`scripts/ai_api_request.sh` on macOS/Linux, `scripts/ai_api_request.ps1` on Windows) is the standard execution path for this skill pack. Use it for credential status checks, credential persistence, validation probes, and all `/api/ai/v1/*` requests.
- Do not replace the helper with an ad hoc request flow when the helper is available.

## Authentication

- The header is exactly:
  - `Authorization: Bearer <access_key_id>.<secret>`
- Never print or restate the secret after it is provided.
- Never substitute a website login token, email, or password for the AI credential. Never ask the user for their SUP account password.

Read: `references/auth-and-headers.md`
Read credential discovery and persistence rules before asking for credentials: `references/local-config.md`

## Signing In

When `status` reports `ready: no`, or the API returns `401`:

1. Run the helper's `login` command. It prints a link and an 8-letter code, tries to open the link in the user's browser, then waits up to about 100 seconds.
2. Tell the user, in the conversation, the link and the code from the output, and ask them to open the link, sign in to SUP Dropshipping if asked, check the code matches, and click **Allow**. If the output says the browser was opened, say so.
3. If `login` exits with `0`, the credential is saved. Continue with the validation probe.
4. If it exits with `3` (not approved yet), wait for the user to say they clicked Allow, then run `login --wait`. Do not start a new `login` while one is pending, so the user does not end up with two codes.
5. If it fails with "denied" or "expired", explain that and offer to start again.

Notes:
- Each SUP Dropshipping account has one AI connection. Approving a new sign-in disconnects any other computer that used the previous one. Mention this if the user says they use several computers.
- On a machine without a browser (for example over SSH), run `login --no-browser`; the user can open the link on any device.
- Never ask for the user's SUP account password. Signing in happens on the SUP Dropshipping website only.

## Validation Probe

- Before the first business request in a session, validate connectivity and credentials with:
  - `GET /api/ai/v1/dashboard`
- If that returns `401` with `code=unauthorized`, the saved credential was replaced or removed. Run the sign-in flow again.

## Read-Only Boundary

- The current skill pack is read-only. The API rejects every non-GET request with `405`.
- Only use `/api/ai/v1/*` routes. Do not call any other `/api/*` route of the website.
- Do not invent write calls such as create, pay, cancel, connect, import, recharge, or update actions.
- If the user asks for a write operation, explain that the AI API is read-only, tell them to do it in the SUP Dropshipping website, and stop.

## Request Defaults

- Dates are sent as `YYYY-MM-DD`.
- Unless the user specifies otherwise, start with `page=1` and `per_page=50`.
- The maximum `per_page` is `100`.
- Only send documented parameters. Do not guess hidden filters.

Read: `references/pagination-and-dates.md`

## Rate Limits And Retries

- The limit is per credential (60 requests per minute by default).
- The helper prints these response headers on stderr when present:
  - `X-RateLimit-Limit`
  - `X-RateLimit-Remaining`
  - `X-RateLimit-Reset`
  - `Retry-After`
- If the API returns `429` with `code=rate_limit_exceeded`, wait `Retry-After` seconds and retry once.
- Fetch pages of the same resource one after another, not in parallel.

## Error Handling

- Treat the HTTP status as the first classifier, then the JSON `code` field.
- Common cases:
  - `401` + `unauthorized`: credentials are missing, wrong, or revoked
  - `404` + `resource_not_found`: the object does not exist in this account
  - `405` + `method_not_allowed`: a write was attempted; the API is read-only
  - `422` + endpoint-specific code: the request shape or a filter value is invalid
  - `429` + `rate_limit_exceeded`: back off and retry once
  - `5xx`: stop and report the failure without retry loops

Read: `references/errors-and-retries.md`

## Customer Data Handling

- Treat buyer names, addresses, phone numbers, emails, order numbers, tracking numbers, and wallet balances as customer data.
- Summarize results instead of echoing large raw payloads. Only show buyer contact details when the user asks for them.
- All cost and balance amounts are in USD unless a field says otherwise.
- Do not expose credentials in logs, notes, or examples. If shell commands are shown, use `${SUP_AI_SECRET}` instead of a literal secret.
- Do not print local config file contents; they contain the `secret`.

## Domain Routing

- `sup-dropshipping-dashboard`: account summary (balance, credit, order counts) and the list of connected stores.
- `sup-dropshipping-orders`: store orders, their costs, status, buyers, and tracking.
- `sup-dropshipping-products`: store products connected to SUP products, with variant mapping.
- `sup-dropshipping-inventory`: the user's private stock held in SUP warehouses.
- `sup-dropshipping-billing-logs`: wallet transaction history.
- `sup-dropshipping-invoices`: invoices the user created for their own customers.
- `sup-dropshipping-sourcing`: sourcing requests and SUP's replies.

## References

- `references/auth-and-headers.md`
- `references/local-config.md`
- `references/errors-and-retries.md`
- `references/pagination-and-dates.md`

## Troubleshooting

- Use raw HTTP requests only as a last-resort fallback when the installed helper is unavailable.
- For account or integration issues, the user should contact their SUP Dropshipping agent.
