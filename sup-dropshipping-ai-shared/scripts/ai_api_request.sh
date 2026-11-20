#!/bin/sh
# SUP Dropshipping read-only AI API helper (macOS / Linux).
#
#   ai_api_request.sh status
#   ai_api_request.sh login [--wait] [--no-browser] [--scope user|repo]
#   ai_api_request.sh set-from-env [--scope user|repo]
#   ai_api_request.sh request /api/ai/v1/orders [--param key=value ...]
#
# Credentials are resolved from environment variables, then config files.
# The secret is never printed.
set -eu

DEFAULT_BASE_URL="https://www.supdropshipping.com"
USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/sup-dropshipping/ai-api.json"
LOGIN_PENDING="${XDG_CONFIG_HOME:-$HOME/.config}/sup-dropshipping/login-pending"
LOGIN_WAIT_SECONDS="${SUP_AI_LOGIN_WAIT:-100}"
REPO_CONFIG_NAME=".sup-dropshipping-ai.local.json"

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

# Read one string value from a flat JSON file. Accepts lower-case keys and
# the upper-case environment-style keys.
json_get() {
  file="$1"
  key="$2"
  [ -f "$file" ] || return 0
  tr -d '\r\n' < "$file" | sed -n 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

find_repo_config() {
  dir="$(pwd -P)"
  while :; do
    if [ -f "$dir/$REPO_CONFIG_NAME" ]; then
      printf '%s\n' "$dir/$REPO_CONFIG_NAME"
      return 0
    fi
    [ "$dir" = "/" ] && return 0
    dir="$(dirname "$dir")"
  done
}

BASE_URL=""
ACCESS_KEY_ID=""
SECRET=""
SOURCE_BASE_URL="default"
SOURCE_ACCESS_KEY_ID="missing"
SOURCE_SECRET="missing"

fill_from_file() {
  file="$1"
  label="$2"
  [ -n "$file" ] && [ -f "$file" ] || return 0
  if [ -z "$BASE_URL" ]; then
    value="$(json_get "$file" base_url)"
    [ -n "$value" ] || value="$(json_get "$file" SUP_AI_BASE_URL)"
    if [ -n "$value" ]; then BASE_URL="$value"; SOURCE_BASE_URL="$label"; fi
  fi
  if [ -z "$ACCESS_KEY_ID" ]; then
    value="$(json_get "$file" access_key_id)"
    [ -n "$value" ] || value="$(json_get "$file" SUP_AI_ACCESS_KEY_ID)"
    if [ -n "$value" ]; then ACCESS_KEY_ID="$value"; SOURCE_ACCESS_KEY_ID="$label"; fi
  fi
  if [ -z "$SECRET" ]; then
    value="$(json_get "$file" secret)"
    [ -n "$value" ] || value="$(json_get "$file" SUP_AI_SECRET)"
    if [ -n "$value" ]; then SECRET="$value"; SOURCE_SECRET="$label"; fi
  fi
}

resolve_credentials() {
  if [ -n "${SUP_AI_BASE_URL:-}" ]; then BASE_URL="$SUP_AI_BASE_URL"; SOURCE_BASE_URL="env"; fi
  if [ -n "${SUP_AI_ACCESS_KEY_ID:-}" ]; then ACCESS_KEY_ID="$SUP_AI_ACCESS_KEY_ID"; SOURCE_ACCESS_KEY_ID="env"; fi
  if [ -n "${SUP_AI_SECRET:-}" ]; then SECRET="$SUP_AI_SECRET"; SOURCE_SECRET="env"; fi

  if [ -n "${SUP_AI_CONFIG:-}" ]; then
    fill_from_file "$SUP_AI_CONFIG" "config:$SUP_AI_CONFIG"
  fi
  repo_config="$(find_repo_config)"
  fill_from_file "$repo_config" "config:$repo_config"
  fill_from_file "$USER_CONFIG" "config:$USER_CONFIG"

  [ -n "$BASE_URL" ] || BASE_URL="$DEFAULT_BASE_URL"
  BASE_URL="${BASE_URL%/}"
}

cmd_status() {
  resolve_credentials
  printf 'base_url: %s (%s)\n' "$BASE_URL" "$SOURCE_BASE_URL"
  if [ -n "$ACCESS_KEY_ID" ]; then
    printf 'access_key_id: set (%s)\n' "$SOURCE_ACCESS_KEY_ID"
  else
    printf 'access_key_id: missing\n'
  fi
  if [ -n "$SECRET" ]; then
    printf 'secret: set (%s)\n' "$SOURCE_SECRET"
  else
    printf 'secret: missing\n'
  fi
  if [ -n "$ACCESS_KEY_ID" ] && [ -n "$SECRET" ]; then
    printf 'ready: yes\n'
  else
    printf 'ready: no\n'
    printf 'To connect, run: ai_api_request.sh login\n'
    exit 2
  fi
}

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

# Credentials issued by SUP only contain letters, digits, "_" and "-".
check_token_chars() {
  case "$2" in
    *[!A-Za-z0-9_-]*) die "$1 contains unexpected characters; copy it again from the SUP account page" ;;
  esac
}

# Write base_url / access_key_id / secret to the user or repo config file.
write_config() {
  scope="$1"; w_base="$2"; w_key="$3"; w_secret="$4"
  case "$scope" in
    user) target="$USER_CONFIG" ;;
    repo) target="$(pwd -P)/$REPO_CONFIG_NAME" ;;
    *) die "--scope must be user or repo" ;;
  esac
  mkdir -p "$(dirname "$target")"
  old_umask="$(umask)"
  umask 077
  {
    printf '{\n'
    printf '  "base_url": "%s",\n' "$(json_escape "${w_base%/}")"
    printf '  "access_key_id": "%s",\n' "$(json_escape "$w_key")"
    printf '  "secret": "%s"\n' "$(json_escape "$w_secret")"
    printf '}\n'
  } > "$target"
  umask "$old_umask"
  chmod 600 "$target" 2>/dev/null || true
  SAVED_TO="$target"
}

cmd_set_from_env() {
  scope="user"
  while [ $# -gt 0 ]; do
    case "$1" in
      --scope) [ $# -ge 2 ] || die "--scope needs a value"; scope="$2"; shift 2 ;;
      *) die "unknown argument: $1" ;;
    esac
  done
  [ -n "${SUP_AI_ACCESS_KEY_ID:-}" ] || die "SUP_AI_ACCESS_KEY_ID is not set in the environment"
  [ -n "${SUP_AI_SECRET:-}" ] || die "SUP_AI_SECRET is not set in the environment"
  check_token_chars "SUP_AI_ACCESS_KEY_ID" "$SUP_AI_ACCESS_KEY_ID"
  check_token_chars "SUP_AI_SECRET" "$SUP_AI_SECRET"
  write_config "$scope" "${SUP_AI_BASE_URL:-$DEFAULT_BASE_URL}" "$SUP_AI_ACCESS_KEY_ID" "$SUP_AI_SECRET"
  printf 'Saved credentials to %s\n' "$SAVED_TO"
  if [ "$scope" = "repo" ]; then
    printf 'Make sure %s is listed in .gitignore.\n' "$REPO_CONFIG_NAME"
  fi
}

# Read one string or number value from a JSON text (flat objects only).
json_text_get() {
  printf '%s' "$1" | tr -d '\r\n' | sed -n 's/.*"'"$2"'"[[:space:]]*:[[:space:]]*"\{0,1\}\([^",}]*\)"\{0,1\}.*/\1/p'
}

# POST a form to the API without credentials. Sets POST_STATUS and POST_BODY.
post_form() {
  pf_path="$1"; shift
  command -v curl >/dev/null 2>&1 || die "curl is required"
  pf_tmp="$(mktemp "${TMPDIR:-/tmp}/sup-ai-post.XXXXXX")"
  POST_STATUS="$(curl -sS -X POST -H 'Accept: application/json' --max-time 30 -o "$pf_tmp" -w '%{http_code}' "$@" "$BASE_URL$pf_path")" || {
    rm -f "$pf_tmp"; die "could not reach $BASE_URL (network error)"
  }
  POST_BODY="$(cat "$pf_tmp")"
  rm -f "$pf_tmp"
}

open_browser() {
  case "$(uname -s 2>/dev/null)" in
    Darwin) open "$1" >/dev/null 2>&1 && return 0 ;;
    Linux)
      if command -v xdg-open >/dev/null 2>&1 && { [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; }; then
        xdg-open "$1" >/dev/null 2>&1 && return 0
      fi
      ;;
  esac
  return 1
}

# Browser sign-in: the user approves in their SUP Dropshipping account and the
# credential is saved locally. It never passes through the chat.
cmd_login() {
  scope="user"; wait_only=0; no_browser=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --scope) [ $# -ge 2 ] || die "--scope needs a value"; scope="$2"; shift 2 ;;
      --wait) wait_only=1; shift ;;
      --no-browser) no_browser=1; shift ;;
      *) die "unknown argument: $1" ;;
    esac
  done
  case "$scope" in user|repo) ;; *) die "--scope must be user or repo" ;; esac
  resolve_credentials

  if [ "$wait_only" -eq 1 ]; then
    [ -f "$LOGIN_PENDING" ] || die "no sign-in is in progress; run: ai_api_request.sh login"
    device_code="$(sed -n 's/^device_code=//p' "$LOGIN_PENDING")"
    user_code="$(sed -n 's/^user_code=//p' "$LOGIN_PENDING")"
    url="$(sed -n 's/^url=//p' "$LOGIN_PENDING")"
    interval="$(sed -n 's/^interval=//p' "$LOGIN_PENDING")"
    pending_base="$(sed -n 's/^base_url=//p' "$LOGIN_PENDING")"
    scope="$(sed -n 's/^scope=//p' "$LOGIN_PENDING")"
    [ -n "$pending_base" ] && BASE_URL="$pending_base"
    printf 'Still waiting for approval of code %s at:\n  %s\n' "$user_code" "$url"
  else
    client_name="$(hostname 2>/dev/null || printf 'computer') ($(uname -s 2>/dev/null || printf 'unknown'))"
    post_form /api/ai/device/code --data-urlencode "client_name=$client_name"
    [ "$POST_STATUS" = "200" ] || die "could not start sign-in (HTTP $POST_STATUS): $POST_BODY"
    device_code="$(json_text_get "$POST_BODY" device_code)"
    user_code="$(json_text_get "$POST_BODY" user_code)"
    url="$(json_text_get "$POST_BODY" verification_uri_complete | sed 's#\\/#/#g')"
    interval="$(json_text_get "$POST_BODY" interval)"
    [ -n "$device_code" ] && [ -n "$user_code" ] && [ -n "$url" ] || die "unexpected response from server: $POST_BODY"
    mkdir -p "$(dirname "$LOGIN_PENDING")"
    old_umask="$(umask)"; umask 077
    printf 'device_code=%s\nuser_code=%s\nurl=%s\ninterval=%s\nbase_url=%s\nscope=%s\n' \
      "$device_code" "$user_code" "$url" "${interval:-5}" "$BASE_URL" "$scope" > "$LOGIN_PENDING"
    umask "$old_umask"

    printf 'To connect this computer to your SUP Dropshipping account:\n'
    printf '  1. Open this link (sign in to SUP Dropshipping if asked):\n     %s\n' "$url"
    printf '  2. Check that the page shows the code: %s\n' "$user_code"
    printf '  3. Click "Allow".\n'
    if [ "$no_browser" -eq 0 ] && open_browser "$url"; then
      printf 'The link was opened in your browser.\n'
    fi
    printf 'Waiting for approval...\n'
  fi

  case "${interval:-5}" in ''|*[!0-9]*) interval=5 ;; esac
  [ "$interval" -ge 1 ] || interval=5
  waited=0
  while [ "$waited" -lt "$LOGIN_WAIT_SECONDS" ]; do
    sleep "$interval"
    waited=$((waited + interval))
    post_form /api/ai/device/token --data-urlencode "device_code=$device_code"
    if [ "$POST_STATUS" = "200" ]; then
      key="$(json_text_get "$POST_BODY" access_key_id)"
      secret="$(json_text_get "$POST_BODY" secret)"
      account="$(json_text_get "$POST_BODY" account)"
      base="$(json_text_get "$POST_BODY" base_url | sed 's#\\/#/#g')"
      check_token_chars "access_key_id" "$key"
      check_token_chars "secret" "$secret"
      write_config "$scope" "${base:-$BASE_URL}" "$key" "$secret"
      rm -f "$LOGIN_PENDING"
      printf 'Connected%s. Credentials saved to %s\n' "${account:+ as $account}" "$SAVED_TO"
      return 0
    fi
    code="$(json_text_get "$POST_BODY" code)"
    case "$code" in
      authorization_pending) ;;
      slow_down) interval=$((interval + 5)) ;;
      access_denied) rm -f "$LOGIN_PENDING"; die "the request was denied in the browser" ;;
      expired_token|invalid_device_code) rm -f "$LOGIN_PENDING"; die "the sign-in request expired or was already used; run: ai_api_request.sh login" ;;
      *) die "sign-in failed (HTTP $POST_STATUS): $POST_BODY" ;;
    esac
  done

  printf 'Not approved yet. After clicking "Allow" in the browser, run: ai_api_request.sh login --wait\n'
  exit 3
}

cmd_request() {
  [ $# -ge 1 ] || die "usage: ai_api_request.sh request /api/ai/v1/<resource> [--param key=value ...]"
  path="$1"
  shift
  case "$path" in
    /api/ai/v1/*) ;;
    *) die "only /api/ai/v1/* paths are allowed (got: $path)" ;;
  esac
  case "$path" in
    *[!A-Za-z0-9/_.-]*) die "path contains unsupported characters; pass filters with --param key=value" ;;
  esac

  command -v curl >/dev/null 2>&1 || die "curl is required"
  resolve_credentials
  [ -n "$ACCESS_KEY_ID" ] && [ -n "$SECRET" ] || die "credentials are not configured; run: ai_api_request.sh status"
  check_token_chars "access_key_id" "$ACCESS_KEY_ID"
  check_token_chars "secret" "$SECRET"

  tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/sup-ai.XXXXXX")"
  trap 'rm -rf "$tmp_dir"' EXIT INT TERM
  body_file="$tmp_dir/body"
  header_file="$tmp_dir/headers"

  set -- "$@" __END__
  while [ "$1" != "__END__" ]; do
    case "$1" in
      --param)
        [ "$2" != "__END__" ] || die "--param needs key=value"
        case "$2" in
          *=*) ;;
          *) die "--param needs key=value (got: $2)" ;;
        esac
        set -- "$@" --data-urlencode "$2"
        shift 2
        ;;
      *) die "unknown argument: $1" ;;
    esac
  done
  shift

  # The Authorization header is passed through stdin so the secret never
  # appears in the process list or in shell output.
  status="$(printf 'header = "Authorization: Bearer %s.%s"\n' "$ACCESS_KEY_ID" "$SECRET" | curl -sS -G --config - \
    -H 'Accept: application/json' \
    --max-time 60 \
    -D "$header_file" -o "$body_file" -w '%{http_code}' \
    "$@" "$BASE_URL$path")" || die "request failed (network error)"

  cat "$body_file"
  printf '\n'

  {
    printf 'HTTP %s\n' "$status"
    grep -i -E '^(x-ratelimit-[a-z]+|retry-after):' "$header_file" | tr -d '\r' || true
  } >&2

  case "$status" in
    2*) exit 0 ;;
    *) exit 1 ;;
  esac
}

[ $# -ge 1 ] || die "usage: ai_api_request.sh status | login [--wait] | set-from-env [--scope user|repo] | request <path> [--param key=value ...]"
command="$1"
shift
case "$command" in
  status) cmd_status ;;
  login) cmd_login "$@" ;;
  set-from-env) cmd_set_from_env "$@" ;;
  request) cmd_request "$@" ;;
  *) die "unknown command: $command" ;;
esac
