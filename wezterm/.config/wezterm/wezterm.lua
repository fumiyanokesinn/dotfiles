-- =====================================
-- WezTerm Configuration
-- =====================================

local wezterm = require 'wezterm'
local config = {}

-- Use config builder for better error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- =====================================
-- Shell
-- =====================================
config.default_prog = { '/opt/homebrew/bin/fish' }

-- =====================================
-- Font
-- =====================================
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14.0

-- =====================================
-- Appearance
-- =====================================
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20

-- Hide title bar
config.window_decorations = "RESIZE"

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true

-- =====================================
-- Window
-- =====================================
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- =====================================
-- Scrollback
-- =====================================
config.scrollback_lines = 20000

-- =====================================
-- Key Bindings
-- =====================================
config.keys = {
  -- Split panes
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'D',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Navigate panes (Vim-like)
  {
    key = 'h',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  -- Close pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

return config
