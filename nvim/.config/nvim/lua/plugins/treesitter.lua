return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "go", "gomod", "gosum", "lua", "vim", "vimdoc", "typescript", "javascript", "tsx", "json", "bash", "python" },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    })
  end,
}
