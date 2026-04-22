#!/bin/bash
# Claude Code → cmux サイドバー状態転送フック
# OS 通知は cmux 側で発火するため、ここでは出さない（二重通知防止）

set -u

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')

CMUX_BIN="/Applications/cmux NIGHTLY.app/Contents/Resources/bin/cmux"
[ -x "$CMUX_BIN" ] || CMUX_BIN="$(command -v cmux || true)"

if [ -n "$CMUX_BIN" ] && [ -n "${CMUX_WORKSPACE_ID:-}" ]; then
  case "$EVENT_TYPE" in
    Stop|SubagentStop)  echo "$EVENT" | "$CMUX_BIN" claude-hook stop          >/dev/null 2>&1 ;;
    SessionStart)       echo "$EVENT" | "$CMUX_BIN" claude-hook session-start >/dev/null 2>&1 ;;
    UserPromptSubmit)   echo "$EVENT" | "$CMUX_BIN" claude-hook prompt-submit >/dev/null 2>&1 ;;
    Notification)       echo "$EVENT" | "$CMUX_BIN" claude-hook notification  >/dev/null 2>&1 ;;
  esac
fi

exit 0
