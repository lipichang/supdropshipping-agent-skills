#!/bin/sh
# Installer for the SUP Dropshipping agent skills (macOS / Linux).
# Copies every sup-dropshipping-* skill folder into the skills directory of
# each AI tool detected under the current user's home directory.
set -eu

REPO_OWNER="${SUP_AGENT_SKILLS_OWNER:-YOUR_GITHUB_ORG}"
REPO_NAME="${SUP_AGENT_SKILLS_REPO:-supdropshipping-agent-skills}"
REPO_REF="main"
SKILL_PREFIX="sup-dropshipping-"
BACKUP_DIR_NAME=".supdropshipping-agent-skills-backups"
DRY_RUN=0
SOURCE_DIR=""
SELECTED_TOOLS=""
TEMP_DIR=""

# key|display name|detect directory|skills directory|support level
TOOLS="claude_code|Claude Code|$HOME/.claude|$HOME/.claude/skills|verified
codex|Codex|$HOME/.codex|$HOME/.codex/skills|verified
openclaw|OpenClaw|$HOME/.openclaw|$HOME/.openclaw/skills|best-effort
cursor|Cursor|$HOME/.cursor|$HOME/.cursor/skills|best-effort
antigravity|Antigravity|$HOME/.gemini/antigravity|$HOME/.gemini/antigravity/skills|best-effort
opencode|OpenCode|$HOME/.config/opencode|$HOME/.config/opencode/skills|best-effort
continue|Continue|$HOME/.continue|$HOME/.continue/skills|best-effort
gemini_cli|Gemini CLI|$HOME/.gemini|$HOME/.gemini/skills|best-effort
github_copilot|GitHub Copilot|$HOME/.copilot|$HOME/.copilot/skills|best-effort
qwen_code|Qwen Code|$HOME/.qwen|$HOME/.qwen/skills|best-effort
windsurf|Windsurf|$HOME/.codeium/windsurf|$HOME/.codeium/windsurf/skills|best-effort"

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then rm -rf "$TEMP_DIR"; fi
}
trap cleanup EXIT INT TERM

usage() {
  cat <<'USAGE'
Usage:
  sh install.sh [--dry-run] [--ref REF] [--tool KEY ...] [--source-dir PATH]

Options:
  --dry-run          Show detected tools and planned actions without changing files
  --ref REF          GitHub branch or tag to install from (default: main)
  --tool KEY         Install only into the given tool; may be repeated
                     Keys: claude_code codex openclaw cursor antigravity opencode
                           continue gemini_cli github_copilot qwen_code windsurf
  --source-dir PATH  Install from a local copy of this repository instead of GitHub
  -h, --help         Show this help
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --ref) [ $# -ge 2 ] || die "--ref needs a value"; REPO_REF="$2"; shift 2 ;;
    --tool) [ $# -ge 2 ] || die "--tool needs a value"; SELECTED_TOOLS="$SELECTED_TOOLS $2"; shift 2 ;;
    --source-dir) [ $# -ge 2 ] || die "--source-dir needs a value"; SOURCE_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1 (see --help)" ;;
  esac
done

tool_selected() {
  [ -z "$SELECTED_TOOLS" ] && return 0
  for selected in $SELECTED_TOOLS; do
    [ "$selected" = "$1" ] && return 0
  done
  return 1
}

for selected in $SELECTED_TOOLS; do
  printf '%s\n' "$TOOLS" | grep -q "^$selected|" || die "unknown tool key: $selected (see --help)"
done

download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    die "curl or wget is required to download the skills"
  fi
}

locate_source() {
  if [ -n "$SOURCE_DIR" ]; then
    [ -d "$SOURCE_DIR" ] || die "source directory not found: $SOURCE_DIR"
    SOURCE_ROOT="$(CDPATH= cd -- "$SOURCE_DIR" && pwd -P)"
    return
  fi
  # Running from an unpacked copy of the repository
  if [ -f "$0" ]; then
    script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
    if [ -f "$script_dir/${SKILL_PREFIX}ai-shared/SKILL.md" ]; then
      SOURCE_ROOT="$script_dir"
      return
    fi
  fi
  [ "$REPO_OWNER" != "YOUR_GITHUB_ORG" ] || die "the GitHub owner is not configured; set SUP_AGENT_SKILLS_OWNER or use --source-dir"
  command -v unzip >/dev/null 2>&1 || die "unzip is required to install from GitHub"
  TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/sup-agent-skills.XXXXXX")"
  archive="$TEMP_DIR/source.zip"
  log "Downloading $REPO_OWNER/$REPO_NAME@$REPO_REF ..."
  download "https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/heads/$REPO_REF.zip" "$archive" 2>/dev/null \
    || download "https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/tags/$REPO_REF.zip" "$archive" \
    || die "could not download $REPO_OWNER/$REPO_NAME at ref $REPO_REF"
  unzip -q "$archive" -d "$TEMP_DIR/src"
  shared="$(find "$TEMP_DIR/src" -maxdepth 3 -type d -name "${SKILL_PREFIX}ai-shared" | head -n 1)"
  [ -n "$shared" ] || die "the downloaded archive does not contain ${SKILL_PREFIX}ai-shared"
  SOURCE_ROOT="$(dirname "$shared")"
}

SOURCE_ROOT=""
locate_source

SKILLS=""
for path in "$SOURCE_ROOT"/"$SKILL_PREFIX"*; do
  [ -f "$path/SKILL.md" ] || continue
  name="$(basename "$path")"
  declared="$(sed -n 's/^name:[[:space:]]*//p' "$path/SKILL.md" | head -n 1 | tr -d '"\r')"
  [ "$declared" = "$name" ] || die "skill folder $name does not match its frontmatter name ($declared)"
  SKILLS="$SKILLS $name"
done
[ -n "$SKILLS" ] || die "no ${SKILL_PREFIX}* skills found in $SOURCE_ROOT"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
INSTALLED=0

log "Source: $SOURCE_ROOT"
log "Skills:$SKILLS"
log ""

OLD_IFS="$IFS"
IFS='
'
for line in $TOOLS; do
  IFS='|'
  set -- $line
  IFS="$OLD_IFS"
  key="$1"; display="$2"; detect_dir="$3"; target_dir="$4"; level="$5"

  tool_selected "$key" || continue
  [ -d "$detect_dir" ] || continue

  INSTALLED=$((INSTALLED + 1))
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY RUN  $display [$level] -> $target_dir"
  else
    mkdir -p "$target_dir"
  fi

  for skill in $SKILLS; do
    target="$target_dir/$skill"
    if [ -e "$target" ]; then
      backup_root="$(dirname "$target_dir")/$BACKUP_DIR_NAME/$key/$TIMESTAMP"
      if [ "$DRY_RUN" -eq 1 ]; then
        log "         backup $skill -> $backup_root/$skill"
      else
        mkdir -p "$backup_root"
        mv "$target" "$backup_root/$skill"
      fi
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      log "         copy   $skill"
    else
      cp -R "$SOURCE_ROOT/$skill" "$target_dir/"
    fi
  done

  if [ "$DRY_RUN" -eq 0 ]; then
    chmod +x "$target_dir/${SKILL_PREFIX}ai-shared/scripts/ai_api_request.sh" 2>/dev/null || true
    log "Installed into $display [$level]: $target_dir"
  fi
done
IFS="$OLD_IFS"

log ""
if [ "$INSTALLED" -eq 0 ]; then
  die "no supported AI tool was detected. Install one first (for example Claude Code or Codex), or check the --tool key."
fi

if [ "$DRY_RUN" -eq 1 ]; then
  log "Dry run only. Nothing was changed."
else
  log "Done. Restart your AI tool, then ask it to connect to your SUP Dropshipping account,"
  log "and ask: \"Show me my SUP Dropshipping account summary.\""
fi
