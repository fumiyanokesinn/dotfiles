-- 基本設定
vim.opt.number = true         -- 行番号
vim.opt.relativenumber = false -- 相対行番号
vim.opt.cursorline = true     -- カーソル行ハイライト
vim.opt.signcolumn = "yes"    -- 左側のサイン列を常に表示
vim.opt.guicursor = "n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20"  -- カーソルを常に線(ビーム)にする

require('config.lazy')
