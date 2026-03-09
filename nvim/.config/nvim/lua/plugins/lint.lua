local cspell_config = vim.fn.expand("~/.config/cspell/cspell.json")

-- カーソル下の単語をグローバル辞書に追加
local function cspell_add_word()
  local word = vim.fn.expand("<cword>")
  if word == "" then return end

  local path = cspell_config
  local content = vim.fn.readfile(path)
  local json = vim.json.decode(table.concat(content, "\n"))

  -- 重複チェック
  for _, w in ipairs(json.words) do
    if w == word then
      vim.notify('"' .. word .. '" is already in dictionary', vim.log.levels.INFO)
      return
    end
  end

  table.insert(json.words, word)
  table.sort(json.words)
  vim.fn.writefile({ vim.json.encode(json) }, path)
  vim.notify('Added "' .. word .. '" to cspell dictionary', vim.log.levels.INFO)

  -- 再lint
  require("lint").try_lint()
end

return {
  -- cspell を Mason 経由で自動インストール
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "cspell",
        "eslint_d",
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    keys = {
      { "<leader>cs", cspell_add_word, desc = "Add word to cspell dictionary" },
    },
    config = function()
      local lint = require("lint")

      -- グローバル辞書を参照（デフォルト args の先頭に -c を追加）
      local cspell = require("lint.linters.cspell")
      table.insert(cspell.args, 1, "-c")
      table.insert(cspell.args, 2, cspell_config)
      lint.linters.cspell = cspell

      lint.linters_by_ft = {
        go = { "cspell" },
        gomod = { "cspell" },
        javascript = { "eslint_d", "cspell" },
        javascriptreact = { "eslint_d", "cspell" },
        typescript = { "eslint_d", "cspell" },
        typescriptreact = { "eslint_d", "cspell" },
        markdown = { "cspell" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
