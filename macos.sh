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

# Restart Dock to apply changes
killall Dock

echo "Done! Some settings may require logout to take effect."
