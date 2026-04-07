#!/bin/bash
# macOS defaults settings
# Usage: ./macos.sh
# Note: Some settings require logout or restart to take effect.

set -euo pipefail

echo "==> Applying macOS defaults..."

# Dock: autohide
defaults write com.apple.dock autohide -bool true

# Trackpad: tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Hot corner: bottom-right = Quick Note (14)
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# Spelling: auto-correction enabled
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Appearance: Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Keyboard shortcuts:
#   Cmd+Space  -> Input source switch (半角/全角)
#   Ctrl+Space -> Raycast (Raycast側で設定)
#   Spotlight  -> disabled

# Disable Spotlight shortcut (Cmd+Space, key 64)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '{enabled=0;value={parameters=(65535,49,1048576);type=standard;};}'

# Enable input source switch on Cmd+Space (key 61)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '{enabled=1;value={parameters=(32,49,1048576);type=standard;};}'

# Disable default input source switch Ctrl+Space (key 60) - used by Raycast instead
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '{enabled=0;value={parameters=(32,49,262144);type=standard;};}'

# Restart Dock to apply changes
killall Dock

echo "Done! Some settings may require logout to take effect."
