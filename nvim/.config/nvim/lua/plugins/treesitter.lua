return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim-treesitter-start", {}),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- 既に開いているバッファにもTreesitterハイライトを適用
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          vim.api.nvim_buf_call(buf, function()
            pcall(vim.treesitter.start)
          end)
        end
      end
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
