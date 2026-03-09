-- 基本設定
vim.opt.number = true         -- 行番号
vim.opt.relativenumber = false -- 相対行番号
vim.opt.cursorline = true     -- カーソル行ハイライト
vim.opt.signcolumn = "yes"    -- 左側のサイン列を常に表示
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"  -- インサートモードのみ縦線カーソル

require('config.lazy')

-- gitリポジトリ内なら起動時にバックグラウンドでfetch
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.finddir(".git", ".;") ~= "" then
      vim.fn.jobstart("git fetch --all --quiet", { detach = true })
    end
  end,
})
