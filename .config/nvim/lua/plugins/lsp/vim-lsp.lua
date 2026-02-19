-- vim-lsp
vim.g.lsp_auto_enable = false
vim.keymap.set("n", "<leader>lp", ":call lsp#enable()<CR>", { noremap = true, silent = true })
