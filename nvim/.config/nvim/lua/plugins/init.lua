return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "gosum", "lua", "vim", "vimdoc", "typescript", "javascript", "tsx", "json" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", limit = 5, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", limit = 8, padding = 1 },
          { section = "startup" },
        },
      },
      picker = { enabled = true },
    },
    keys = {
      -- ファイル検索
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      -- Git
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git file history" },
    },
  },
}