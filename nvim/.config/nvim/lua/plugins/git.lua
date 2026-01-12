return {
  -- 行ごとのGit差分表示
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signs_staged_enable = true,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = { buffer = bufnr }

        -- ナビゲーション
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Next hunk" })

        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true, desc = "Prev hunk" })

        -- アクション
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
        vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
        vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
        vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts)
        vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
        vim.keymap.set("n", "<leader>hR", gs.reset_buffer, opts)
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
        vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
        vim.keymap.set("n", "<leader>hd", gs.diffthis, opts)
        vim.keymap.set("n", "<leader>hD", function() gs.diffthis("~") end, opts)
        vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, opts)
        vim.keymap.set("n", "<leader>td", gs.toggle_deleted, opts)
      end,
    },
  },
}
