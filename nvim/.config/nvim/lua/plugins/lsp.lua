return {
  -- LSPサーバー管理
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- mason と lspconfig の連携
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "gopls",
        "ts_ls",
      },
    },
  },

  -- LSP設定 (nvim 0.11+ 対応)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- LSPファイルウォッチャーのENOENTエラー回避
      local ok, wf = pcall(require, "vim.lsp._watchfiles")
      if ok then
        wf._watchfunc = function() return function() end end
      end

      -- 共通キーマップ
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)
          vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, opts)
          vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts)
          vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)
          vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)
          vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
          end, { buffer = args.buf, desc = "Organize imports" })
          -- フォーマットは conform.nvim に委譲
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      -- Go
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.mod", "go.work", ".git" },
        settings = {
          gopls = {
            buildFlags = { "-tags=unit,integration,e2e,test" },
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      }

      -- LSPを有効化
      vim.lsp.enable({ "gopls", "ts_ls" })
    end,
  },
}
