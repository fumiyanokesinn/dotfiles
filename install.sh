#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Stow packages (XDG / home directory) ---
STOW_PACKAGES=(fish starship git nvim kitty cspell)

echo "==> Stow packages: ${STOW_PACKAGES[*]}"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
    echo "  [ok] $pkg"
  else
    echo "  [skip] $pkg (not found)"
  fi
done

# --- VSCode ---
VSCODE_TARGET="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_TARGET" ]; then
  echo "==> VSCode"
  stow --no-folding -d "$DOTFILES_DIR" -t "$VSCODE_TARGET" vscode
  echo "  [ok] settings.json, keybindings.json"

  # Install extensions
  if command -v code &>/dev/null && [ -f "$DOTFILES_DIR/vscode/extensions.txt" ]; then
    echo "  Installing extensions..."
    while IFS= read -r ext; do
      [ -n "$ext" ] && code --install-extension "$ext" --force 2>/dev/null &
    done < "$DOTFILES_DIR/vscode/extensions.txt"
    wait
    echo "  [ok] extensions"
  fi
else
  echo "==> VSCode [skip] (VSCode not installed)"
fi

# --- Claude Code ---
CLAUDE_DIR="$HOME/.claude"
echo "==> Claude Code"

link_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "  [backup] $dst -> $dst.bak"
  fi
  ln -s "$src" "$dst"
}

link_file "$DOTFILES_DIR/claude/CLAUDE.md"                   "$CLAUDE_DIR/CLAUDE.md"
link_file "$DOTFILES_DIR/claude/.mcp.json"                   "$CLAUDE_DIR/.mcp.json"
link_file "$DOTFILES_DIR/claude/.claude/settings.local.json" "$CLAUDE_DIR/.claude/settings.local.json"

# agents
for agent in "$DOTFILES_DIR/claude/agents/"*.md; do
  [ -f "$agent" ] || continue
  link_file "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

echo "  [ok] CLAUDE.md, .mcp.json, agents/, .claude/settings.local.json"

# --- gh CLI ---
echo "==> gh CLI"
link_file "$DOTFILES_DIR/gh/.config/gh/config.yml" "$HOME/.config/gh/config.yml"
echo "  [ok] config.yml (hosts.yml is machine-specific, run 'gh auth login')"

# --- npm/pnpm ---
echo "==> npm/pnpm"
link_file "$DOTFILES_DIR/npm/.npmrc" "$HOME/.npmrc"
echo "  [ok] .npmrc"

# --- Homebrew ---
echo "==> Homebrew"
if command -v brew &>/dev/null && [ -f "$DOTFILES_DIR/Brewfile" ]; then
  echo "  Installing from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
  echo "  [ok] Brewfile"
elif [ -f "$DOTFILES_DIR/Brewfile" ]; then
  echo "  [skip] brew not found. Install Homebrew first: https://brew.sh"
else
  echo "  [skip] Brewfile not found"
fi

# --- Raycast ---
echo "==> Raycast"
RAYCONFIG="$DOTFILES_DIR/raycast/Raycast.rayconfig"
RAYCAST_PLIST="$DOTFILES_DIR/raycast/com.raycast.macos.plist"
if [ -f "$RAYCONFIG" ]; then
  echo "  [info] .rayconfig found: $RAYCONFIG"
  echo "  To import: open \"$RAYCONFIG\" (or Raycast > Settings > Advanced > Import)"
  open "$RAYCONFIG" 2>/dev/null || true
elif [ -f "$RAYCAST_PLIST" ]; then
  echo "  [info] Importing plist settings..."
  defaults import com.raycast.macos "$RAYCAST_PLIST"
  echo "  [ok] plist imported"
else
  echo "  [skip] No rayconfig or plist found"
fi

# --- macOS defaults ---
echo "==> macOS defaults"
if [ -f "$DOTFILES_DIR/macos.sh" ]; then
  read -p "  Apply macOS defaults? (y/N): " apply_macos
  if [ "$apply_macos" = "y" ] || [ "$apply_macos" = "Y" ]; then
    bash "$DOTFILES_DIR/macos.sh"
    echo "  [ok] macOS defaults applied"
  else
    echo "  [skip] Run './macos.sh' later to apply"
  fi
fi

echo ""
echo "Done!"
