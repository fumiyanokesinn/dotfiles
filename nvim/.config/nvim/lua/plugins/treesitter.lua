return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "go", "gomod", "gosum", "gowork", "lua", "vim", "vimdoc", "typescript", "javascript", "tsx", "json", "bash", "python" },
      })
    end,
  },

  -- JSX/HTML 自動閉じタグ・リネーム
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- 画面上部に現在の関数/メソッド名をスティッキー表示
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      max_lines = 3,
    },
  },
}
