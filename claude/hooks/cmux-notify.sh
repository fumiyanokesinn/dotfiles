#!/bin/bash
# Claude Code → cmux 通知フック
# 方針:
#   - cmux 側: サイドバー状態転送（Stop/SubagentStop/SessionStart/UserPromptSubmit）
#   - OS 通知: 日本語で厳選（Stop / Notification(permission_prompt|idle_prompt) のみ）
#   - 依頼要約: UserPromptSubmit でキャッシュ → Stop で表示

set -u

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')
SESSION_ID=$(echo "$EVENT" | jq -r '.session_id // ""')
CWD=$(echo "$EVENT" | jq -r '.cwd // ""')

CMUX_BIN="/Applications/cmux NIGHTLY.app/Contents/Resources/bin/cmux"
[ -x "$CMUX_BIN" ] || CMUX_BIN="$(command -v cmux || true)"

CACHE_DIR="/tmp/claude-hook-cache"
mkdir -p "$CACHE_DIR" 2>/dev/null

# プロジェクト名: git repo ルート basename、無ければ cwd basename
get_project_name() {
  local cwd="$1"
  [ -z "$cwd" ] && { echo "unknown"; return; }
  local repo
  repo=$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null) || true
  if [ -n "$repo" ]; then basename "$repo"; else basename "$cwd"; fi
}

# osascript 通知（特殊文字除去）
notify() {
  local title="$1" subtitle="$2" body="$3"
  title="${title//\"/}"; title="${title//\\/}"
  subtitle="${subtitle//\"/}"; subtitle="${subtitle//\\/}"
  body="${body//\"/}"; body="${body//\\/}"
  osascript -e "display notification \"$body\" with title \"$title\" subtitle \"$subtitle\"" >/dev/null 2>&1 &
}

# UserPromptSubmit: 依頼先頭60文字キャッシュ
if [ "$EVENT_TYPE" = "UserPromptSubmit" ] && [ -n "$SESSION_ID" ]; then
  echo "$EVENT" | jq -r '.prompt // ""' | tr '\n' ' ' | cut -c1-60 > "$CACHE_DIR/prompt-${SESSION_ID}" 2>/dev/null
fi

# cmux 内: サイドバー状態転送（OS 通知は出ない）
if [ -n "$CMUX_BIN" ] && [ -n "${CMUX_WORKSPACE_ID:-}" ]; then
  case "$EVENT_TYPE" in
    Stop|SubagentStop)  echo "$EVENT" | "$CMUX_BIN" claude-hook stop          >/dev/null 2>&1 ;;
    SessionStart)       echo "$EVENT" | "$CMUX_BIN" claude-hook session-start >/dev/null 2>&1 ;;
    UserPromptSubmit)   echo "$EVENT" | "$CMUX_BIN" claude-hook prompt-submit >/dev/null 2>&1 ;;
  esac
fi

# OS 通知（cmux 内外問わず厳選イベントのみ）
PROJECT=$(get_project_name "$CWD")
PROMPT=""
[ -n "$SESSION_ID" ] && PROMPT=$(cat "$CACHE_DIR/prompt-${SESSION_ID}" 2>/dev/null || echo "")

case "$EVENT_TYPE" in
  Stop)
    afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
    notify "完了" "$PROJECT" "$PROMPT"
    ;;
  Notification)
    NTYPE=$(echo "$EVENT" | jq -r '.notification_type // ""')
    case "$NTYPE" in
      permission_prompt)
        afplay /System/Library/Sounds/Ping.aiff >/dev/null 2>&1 &
        notify "許可" "$PROJECT" "$PROMPT"
        ;;
      idle_prompt)
        afplay /System/Library/Sounds/Funk.aiff >/dev/null 2>&1 &
        notify "待機" "$PROJECT" "$PROMPT"
        ;;
    esac
    ;;
esac

exit 0
