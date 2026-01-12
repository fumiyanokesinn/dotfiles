return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeOpen" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
    })
  end,
}
