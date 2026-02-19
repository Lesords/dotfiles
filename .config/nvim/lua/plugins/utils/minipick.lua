-- mini.pick
require('mini.pick').setup()
vim.ui.select = require('mini.pick').ui_select
vim.keymap.set("n", "<space>ff", ":Pick files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>fs", ":Pick grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>fl", ":Pick grep_live<CR>", { noremap = true, silent = true })
