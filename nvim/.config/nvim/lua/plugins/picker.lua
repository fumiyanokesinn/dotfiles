return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>gb", function() Snacks.picker.git_branches({ all = true, finder = "git_branches" }) end, desc = "Git Branches (all)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    },
    opts = {
      picker = {
        sources = {
          git_branches = {
            all = true,
            format = function(item)
              return { { item.branch or item.text, item.current and "SnacksPickerSelected" or "" } }
            end,
          },
        },
      },
    },
  },
}
