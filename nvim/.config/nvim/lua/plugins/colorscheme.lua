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
        -- === VSCode Dark Modern 風カラー ===

        -- ポップアップ
        hl.Pmenu = { bg = "#1a1b26", blend = 80 }
        hl.PmenuSel = { bg = "#04395e" }
        hl.FloatBorder = { fg = "#3c3c3c", bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }

        -- カーソル行
        hl.CursorLine = { bg = "#1a1b26", blend = 50 }

        -- 行番号
        hl.LineNr = { fg = "#858585", bg = "#1a1b26", blend = 70 }
        hl.CursorLineNr = { fg = "#cccccc", bg = "#1a1b26", bold = true, blend = 70 }

        -- コメント（VSCode: #6a9955）
        hl.Comment = { fg = "#6a9955", bg = "NONE", italic = true }
        hl["@comment"] = { link = "Comment" }

        -- キーワード（VSCode: #569cd6）
        hl.Keyword = { fg = "#569cd6" }
        hl["@keyword"] = { fg = "#569cd6" }
        hl["@keyword.return"] = { fg = "#569cd6" }
        hl["@keyword.function"] = { fg = "#569cd6" }
        hl["@keyword.operator"] = { fg = "#569cd6" }
        hl["@conditional"] = { fg = "#c586c0" }
        hl["@keyword.conditional"] = { fg = "#c586c0" }
        hl["@keyword.repeat"] = { fg = "#c586c0" }
        hl["@keyword.import"] = { fg = "#c586c0" }
        hl["@include"] = { fg = "#c586c0" }

        -- 関数（VSCode: #dcdcaa）
        hl.Function = { fg = "#dcdcaa" }
        hl["@function"] = { fg = "#dcdcaa" }
        hl["@function.call"] = { fg = "#dcdcaa" }
        hl["@function.method"] = { fg = "#dcdcaa" }
        hl["@function.method.call"] = { fg = "#dcdcaa" }
        hl["@function.builtin"] = { fg = "#dcdcaa" }

        -- 変数・パラメータ（VSCode: #9cdcfe）
        hl["@variable"] = { fg = "#9cdcfe" }
        hl["@variable.parameter"] = { fg = "#9cdcfe" }
        hl["@variable.member"] = { fg = "#9cdcfe" }

        -- 型（VSCode: #4ec9b0）
        hl.Type = { fg = "#4ec9b0" }
        hl["@type"] = { fg = "#4ec9b0" }
        hl["@type.builtin"] = { fg = "#4ec9b0" }
        hl["@constructor"] = { fg = "#4ec9b0" }

        -- 文字列（VSCode: #ce9178）
        hl.String = { fg = "#ce9178" }
        hl["@string"] = { link = "String" }

        -- 数値（VSCode: #b5cea8）
        hl.Number = { fg = "#b5cea8" }
        hl["@number"] = { fg = "#b5cea8" }
        hl.Boolean = { fg = "#569cd6" }

        -- 演算子（VSCode: #d4d4d4）
        hl.Operator = { fg = "#d4d4d4" }
        hl["@operator"] = { fg = "#d4d4d4" }

        -- Git blame（gitsigns）
        hl.GitSignsCurrentLineBlame = { fg = "#565f89", bg = "NONE", italic = true }

        -- Git差分の行ハイライト（変更箇所を背景色で強調）
        hl.GitSignsAddLn = { bg = "#1a2a1a" }         -- 追加行（緑系）
        hl.GitSignsChangeLn = { bg = "#1a1a2a" }      -- 変更行（青系）
        hl.GitSignsDeleteLn = { bg = "#2a1a1a" }      -- 削除行（赤系）
        hl.GitSignsAddNr = { fg = "#98c379" }          -- 追加行の行番号
        hl.GitSignsChangeNr = { fg = "#61afef" }       -- 変更行の行番号
        hl.GitSignsDeleteNr = { fg = "#e06c75" }       -- 削除行の行番号

        -- Flash
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
