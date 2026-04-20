#!/bin/bash

# Raycast Script Command: cmux 起動 → フルスクリーン化

# @raycast.schemaVersion 1
# @raycast.title cmux
# @raycast.mode silent
# @raycast.packageName Apps
# @raycast.icon 🖥️
# @raycast.description Launch cmux NIGHTLY in fullscreen

set -u

APP_NAME="cmux NIGHTLY"
PROC_NAME="cmux"

open -a "$APP_NAME"

# ウィンドウ出現待ち（最大 ~4 秒）
for _ in $(seq 1 20); do
  exists=$(osascript -e "tell application \"System Events\" to exists (window 1 of process \"$PROC_NAME\")" 2>/dev/null)
  [ "$exists" = "true" ] && break
  sleep 0.2
done

# 既にフルスクリーンなら何もしない
current=$(osascript -e "tell application \"System Events\" to tell process \"$PROC_NAME\" to value of attribute \"AXFullScreen\" of window 1" 2>/dev/null)
if [ "$current" != "true" ]; then
  osascript -e "tell application \"System Events\" to tell process \"$PROC_NAME\" to set value of attribute \"AXFullScreen\" of window 1 to true" >/dev/null 2>&1
fi
