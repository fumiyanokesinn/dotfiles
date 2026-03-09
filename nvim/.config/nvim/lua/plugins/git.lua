return {
  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Diffview (差分ビューア)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>dr",
        function()
          -- ブランチ一覧を取得してピッカーで選択→そのブランチとの差分を表示
          local branches = vim.fn.systemlist("git branch -a --format='%(refname:short)' --sort=-committerdate")
          local current = vim.fn.system("git branch --show-current"):gsub("%s+", "")
          -- 現在のブランチを除外
          branches = vim.tbl_filter(function(b) return b ~= current end, branches)

          vim.ui.select(branches, { prompt = "Base branch:" }, function(choice)
            if not choice then return end
            local base = vim.fn.system("git merge-base HEAD " .. choice):gsub("%s+", "")
            if base == "" then
              vim.notify("merge-base が見つかりません", vim.log.levels.ERROR)
              return
            end
            vim.cmd("DiffviewOpen " .. base .. "...HEAD")
          end)
        end,
        desc = "Diffview PR Review (select base branch)",
      },
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview Toggle Files" },
    },
    config = function(_, opts)
      -- Diffハイライト（視認性向上）
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#264f26" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4f2626" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#263a4f" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b5f" })
      require("diffview").setup(opts)
    end,
    opts = {
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.foldenable = false
          vim.opt_local.foldlevel = 99
          vim.opt_local.foldmethod = "manual"
        end,
        diff_buf_win_enter = function()
          vim.opt_local.foldenable = false
          vim.opt_local.foldlevel = 99
          vim.opt_local.foldmethod = "manual"
        end,
      },
    },
  },

  -- GHLite (GitHub PR レビュー - 軽量)
  {
    "daliusd/ghlite.nvim",
    config = function()
      require("ghlite").setup({
        diff_split = "split",
        diff_tool = "diffview",
      })
    end,
    keys = {
      { "<leader>gl", "<cmd>GHLitePRSelect<cr>", desc = "PR Select" },
      {
        "<leader>go",
        function()
          local gh = require("ghlite.gh")
          local state = require("ghlite.state")
          local utils = require("ghlite.utils")
          utils.notify("Loading PR list...")
          gh.get_pr_list(function(prs)
            if #prs == 0 then
              utils.notify("No PRs found.", vim.log.levels.WARN)
              return
            end
            vim.schedule(function()
              vim.ui.select(prs, {
                prompt = "Select PR to checkout:",
                format_item = function(pr)
                  return string.format("#%s: %s (%s)", pr.number, pr.title, pr.author.login)
                end,
              }, function(pr)
                if pr then
                  state.selected_PR = pr
                  gh.checkout_pr(pr.number, function()
                    utils.notify("Checked out PR #" .. pr.number)
                  end)
                end
              end)
            end)
          end)
        end,
        desc = "PR Checkout",
      },
      { "<leader>gv", "<cmd>GHLitePRView<cr>", desc = "PR View" },
      { "<leader>gp", "<cmd>GHLitePRDiff<cr>", desc = "PR Diff" },
      { "<leader>gd", "<cmd>GHLitePRDiffview<cr>", desc = "PR Diffview" },
    },
  },

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
      numhl = true,
      linehl = true,
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
