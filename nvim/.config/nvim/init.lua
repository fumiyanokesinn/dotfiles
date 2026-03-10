-- Volta (Node/npm) の PATH を確保
vim.env.VOLTA_HOME = vim.env.VOLTA_HOME or (vim.env.HOME .. "/.volta")
if not string.find(vim.env.PATH, vim.env.VOLTA_HOME) then
  vim.env.PATH = vim.env.VOLTA_HOME .. "/bin:" .. vim.env.PATH
end

-- 基本設定
vim.opt.number = true         -- 行番号
vim.opt.relativenumber = false -- 相対行番号
vim.opt.cursorline = true     -- カーソル行ハイライト
vim.opt.signcolumn = "yes"    -- 左側のサイン列を常に表示
vim.opt.clipboard = "unnamedplus" -- システムクリップボード連携
vim.opt.spell = false             -- デフォルトはOFF（コード内の誤検出防止）
vim.opt.spelllang = { "en", "cjk" } -- 英語チェック、日本語は除外
vim.opt.spelloptions = "camel"      -- CamelCaseを単語分割してチェック

-- テキスト系ファイルのみスペルチェック有効
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "go" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"  -- インサートモードのみ縦線カーソル
require('config.lazy')

-- ファイル内置換（カーソル上の単語を自動入力）
vim.keymap.set("n", "<leader>s", ":%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>", { desc = "Replace word under cursor" })
vim.keymap.set("v", "<leader>s", '"zy:%s/<C-r>z/<C-r>z/g<Left><Left>', { desc = "Replace selected text" })

-- ウィンドウ移動（Ctrl+h/j/k/l）
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- インデントガイドの色（レインボー）
local indent_colors = {
  { "SnacksIndent1", { fg = "#E06C75" } },
  { "SnacksIndent2", { fg = "#E5C07B" } },
  { "SnacksIndent3", { fg = "#98C379" } },
  { "SnacksIndent4", { fg = "#56B6C2" } },
  { "SnacksIndent5", { fg = "#61AFEF" } },
  { "SnacksIndent6", { fg = "#C678DD" } },
  { "SnacksIndent7", { fg = "#E06C75" } },
  { "SnacksIndent8", { fg = "#E5C07B" } },
}
for _, v in ipairs(indent_colors) do
  vim.api.nvim_set_hl(0, v[1], v[2])
end

-- gitリポジトリ内なら起動時にバックグラウンドでfetch
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.finddir(".git", ".;") ~= "" then
      vim.fn.jobstart("git fetch --all --quiet", { detach = true })
    end
  end,
})
