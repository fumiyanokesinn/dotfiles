return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = true },
        keywords = { italic = true },
      },
      on_colors = function(colors)
        -- kittyの背景に合わせた調整
        colors.bg_dark = "NONE"
        colors.bg_float = "NONE"
      end,
      on_highlights = function(hl, c)
        -- ポップアップを少し見やすく
        hl.Pmenu = { bg = "#1a1b26", blend = 80 }
        hl.PmenuSel = { bg = "#363b54" }
        hl.FloatBorder = { fg = c.blue, bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }

        -- カーソル行を控えめに
        hl.CursorLine = { bg = "#1a1b26", blend = 50 }

        -- 行番号（背景画像でも見やすく）
        hl.LineNr = { fg = "#a9b1d6", bg = "#1a1b26", blend = 70 }
        hl.CursorLineNr = { fg = "#7aa2f7", bg = "#1a1b26", bold = true, blend = 70 }

        -- コメント（背景なし、明るい色で視認性確保）
        hl.Comment = { fg = "#9ece6a", bg = "NONE", italic = true }
        hl["@comment"] = { link = "Comment" }

        -- Git blame（gitsigns）
        hl.GitSignsCurrentLineBlame = { fg = "#565f89", bg = "NONE", italic = true }

        -- 文字列（VSCode Dark+風）
        hl.String = { fg = "#ce9178" }
        hl["@string"] = { link = "String" }

        -- Flash（ジャンプラベルを目立たせる）
        hl.FlashLabel = { fg = "#000000", bg = "#ff9e64", bold = true }
        hl.FlashMatch = { fg = "#c0caf5", bg = "#3b4261" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
