-- =====================================
-- WezTerm Configuration
-- Kittyの設定に合わせた構成
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
config.line_height = 1.1  -- kittyのadjust_line_height 110%に相当
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }  -- ligatures有効化

-- =====================================
-- Cursor
-- =====================================
config.default_cursor_style = 'SteadyBar'  -- kittyのbeam shapeに相当（点滅なし）
config.cursor_thickness = '1.5pt'

-- =====================================
-- Appearance
-- =====================================
config.color_scheme = 'Tokyo Night'

-- Tokyo Nightのカラー設定（kittyに合わせて詳細指定）
config.colors = {
  foreground = '#c0caf5',
  background = '#1a1b26',
  cursor_bg = '#c0caf5',
  cursor_fg = '#1a1b26',
  cursor_border = '#c0caf5',
  selection_fg = '#c0caf5',
  selection_bg = '#283457',

  -- タブバー
  tab_bar = {
    background = '#15161e',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#16161e',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#292e42',
      fg_color = '#545c7e',
    },
    inactive_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#787c99',
    },
  },

  -- ANSIカラー
  ansi = {
    '#15161e',  -- black
    '#f7768e',  -- red
    '#9ece6a',  -- green
    '#e0af68',  -- yellow
    '#7aa2f7',  -- blue
    '#bb9af7',  -- magenta
    '#7dcfff',  -- cyan
    '#a9b1d6',  -- white
  },
  brights = {
    '#414868',  -- bright black
    '#ff899d',  -- bright red
    '#9fe044',  -- bright green
    '#faba4a',  -- bright yellow
    '#8db0ff',  -- bright blue
    '#c7a9ff',  -- bright magenta
    '#a4daff',  -- bright cyan
    '#c0caf5',  -- bright white
  },
}

-- 背景設定（kittyと同じ）
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20

-- 背景画像（kittyのbackground_pinkerton.confに合わせて）
config.background = {
  {
    source = {
      File = wezterm.home_dir .. '/.config/kitty/backgrounds/ukiyoe.jpg',
    },
    opacity = 0.22,  -- kittyのbackground_image_opacity
    hsb = {
      brightness = 0.85,  -- kittyのbackground_tint
    },
  },
}

-- Hide title bar
config.window_decorations = "RESIZE"

-- Tab bar（kittyのpowerline slanted styleに近い設定）
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false  -- Retro tab barでpowerlineスタイルに
config.tab_bar_at_bottom = false  -- kittyではtop
config.tab_max_width = 32

-- タブのフォーマット（kittyの{index}: {title}に合わせて）
config.tab_bar_style = {
  new_tab = wezterm.format {
    { Background = { Color = '#292e42' } },
    { Foreground = { Color = '#545c7e' } },
    { Text = ' + ' },
  },
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_index + 1 .. ': ' .. tab.active_pane.title
  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

-- =====================================
-- Window
-- =====================================
config.window_padding = {
  left = 6,    -- kittyのwindow_padding_widthに合わせて
  right = 6,
  top = 6,
  bottom = 6,
}

-- =====================================
-- Scrollback
-- =====================================
config.scrollback_lines = 20000
config.enable_scroll_bar = false

-- =====================================
-- Copy on select
-- =====================================
config.quick_select_patterns = {
  -- URLパターンなど
  'https?://\\S+',
}

-- =====================================
-- Key Bindings
-- =====================================
config.keys = {
  -- 新しいタブ（kittyと同じ）
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  -- 分割（kittyと同じ）
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
  -- ペイン移動（kittyのVim風に合わせて）
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
  -- 閉じる（kittyと同じ）
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

-- =====================================
-- Performance
-- =====================================
config.front_end = 'WebGpu'  -- パフォーマンス向上
config.max_fps = 120
config.animation_fps = 60

return config
