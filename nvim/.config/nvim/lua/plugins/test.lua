return {
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
        end,
      },
    },
    config = function()
      --- .envファイルを読み込んで環境変数テーブルを返す
      local function load_dotenv(path)
        local env = {}
        local f = io.open(path, "r")
        if not f then return env end
        for line in f:lines() do
          -- コメントと空行をスキップ
          if not line:match("^%s*#") and line:match("=") then
            local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)")
            if key then
              -- クォートを除去
              value = value:gsub("^[\"'](.-)[\"']$", "%1")
              env[key] = value
            end
          end
        end
        f:close()
        return env
      end

      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            runner = "gotestsum",
            go_test_args = { "-v", "-count=1", "-tags=unit,integration,e2e,test" },
            go_list_args = { "-tags=unit,integration,e2e,test" },
            warn_test_name_dupes = false,
            env = function()
              return load_dotenv(vim.env.HOME .. "/Workspace/palmu-api-go/app/.env")
            end,
          }),
        },
      })

      -- キーマップ
      vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
      vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, { desc = "Run all tests" })
      vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle summary" })
      vim.keymap.set("n", "<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
      vim.keymap.set("n", "<leader>tp", function() require("neotest").output.open({ enter = true }) end, { desc = "Show test output" })
      vim.keymap.set("n", "[t", function() require("neotest").jump.prev({ status = "failed" }) end, { desc = "Prev failed test" })
      vim.keymap.set("n", "]t", function() require("neotest").jump.next({ status = "failed" }) end, { desc = "Next failed test" })
    end,
  },
}
