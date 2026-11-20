# Local Credential Config

## Resolution Order

Resolve credentials before calling any `/api/ai/v1/*` endpoint:

1. Environment variables:
   - `SUP_AI_BASE_URL` (optional)
   - `SUP_AI_ACCESS_KEY_ID`
   - `SUP_AI_SECRET`
2. Explicit config path from `SUP_AI_CONFIG`.
3. Repo-local config discovered from the current working directory upward:
   - `.sup-dropshipping-ai.local.json`
4. User config:
   - macOS/Linux: `~/.config/sup-dropshipping/ai-api.json`
   - Windows: `%USERPROFILE%\.sup-dropshipping\ai-api.json`

Environment variables override file values. File values fill in whatever the environment is missing. If no base URL is found anywhere, `https://www.supdropshipping.com` is used.

## Config Format

```json
{
  "base_url": "https://www.supdropshipping.com",
  "access_key_id": "your_access_key_id",
  "secret": "your_secret"
}
```

Upper-case environment-style keys (`SUP_AI_BASE_URL`, `SUP_AI_ACCESS_KEY_ID`, `SUP_AI_SECRET`) are also accepted in the JSON file.

## Required Workflow

1. Detect the current operating system.
2. Run the helper's `status` command.
3. If it reports `ready: yes`, continue with the validation probe and then the business endpoint.
4. If a value is missing, run browser sign-in (below). It saves to the user config; add `--scope repo` only when the user asks for project-specific credentials.
5. Never print the `secret` or dump the config file.

Status check, macOS/Linux:

```sh
sh ./scripts/ai_api_request.sh status
```

Status check, Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 status
```

`status` prints where each value came from, never the values themselves. It exits with `2` when a credential is missing.

## Browser Sign-In

macOS/Linux:

```sh
sh ./scripts/ai_api_request.sh login
sh ./scripts/ai_api_request.sh login --wait
```

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 login
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 login --wait
```

Options: `--no-browser` (only print the link), `--scope user|repo`, and the environment variable `SUP_AI_LOGIN_WAIT` (seconds to wait in one run, default 100).

Exit codes: `0` connected and saved, `3` still waiting (run `login --wait` after the user approves), `1` denied, expired, or another error.

The sign-in request is valid for 10 minutes. While it is pending it is kept in `~/.config/sup-dropshipping/login-pending` (Windows: `%USERPROFILE%\.sup-dropshipping\login-pending.json`).

## Persist Credentials You Already Have

Only when the user already has an `access_key_id` and `secret` (for example issued by SUP support) and offers them, pass them to the helper through environment variables of that single command. Do not write them into a script file.

macOS/Linux:

```sh
SUP_AI_ACCESS_KEY_ID='...' SUP_AI_SECRET='...' sh ./scripts/ai_api_request.sh set-from-env --scope user
```

Windows PowerShell:

```powershell
$env:SUP_AI_ACCESS_KEY_ID='...'; $env:SUP_AI_SECRET='...'; powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 set-from-env --scope user
```

- Set `SUP_AI_BASE_URL` in the same command only when the user gave a non-default base URL.
- For project-only storage use `--scope repo`. The file `.sup-dropshipping-ai.local.json` must stay gitignored.
- On macOS/Linux the config file is written with permissions `600`.

## API Request Helper

macOS/Linux:

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/orders --param page=1 --param per_page=50
```

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/orders --param page=1 --param per_page=50
```

- Pass every query parameter as its own `--param key=value`. The helper URL-encodes the value.
- The helper only accepts paths under `/api/ai/v1/`.
- It prints the response body and status, never credentials.
