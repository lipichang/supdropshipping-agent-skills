# Authentication And Headers

## Required Inputs

- `access_key_id` (starts with `supak_`)
- `secret`
- Base URL: `https://www.supdropshipping.com` unless the user says otherwise

Resolve these from environment variables first, then local config files. See `local-config.md` before asking the user.

## Authorization Header

```text
Authorization: Bearer <access_key_id>.<secret>
```

The two values are joined with a single dot.

## Validation Example

Use the installed shared helper. It reads environment variables and local config files and never prints the secret. Run it from the installed `sup-dropshipping-ai-shared` skill directory, or adapt the path to that directory.

macOS/Linux:

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/dashboard
```

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/dashboard
```

The helper writes the response body to stdout and the HTTP status plus rate-limit headers to stderr. It exits with `0` on a 2xx response and `1` otherwise.

If the helper is unavailable, a minimal probe is:

```sh
curl -sS \
  -H "Authorization: Bearer ${SUP_AI_ACCESS_KEY_ID}.${SUP_AI_SECRET}" \
  "${SUP_AI_BASE_URL:-https://www.supdropshipping.com}/api/ai/v1/dashboard"
```

## Credential Lifecycle

- The user gets the credential through browser sign-in (`login`). See `local-config.md`.
- One credential per SUP account. Each new sign-in keeps the same `access_key_id` and replaces the `secret`; the previous secret stops working immediately, so another computer using it gets `401` and must sign in again.
- Sign-in uses two unauthenticated endpoints, `POST /api/ai/device/code` and `POST /api/ai/device/token`. Use them only through the helper.

## Important Rules

- Prefer local environment variables and config files over credential values pasted into prompts.
- Do not send a website login token to `/api/ai/v1/*`, and do not call other `/api/*` routes from these skills.
- Do not echo the secret back to the user after it is supplied.
- Never ask for the user's SUP account password.
