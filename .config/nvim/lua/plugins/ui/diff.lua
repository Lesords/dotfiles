-- mini.diff
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#39FF14" })
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#00BFFF" })
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#fb4934" })
require('mini.diff').setup({
    view = {
        signs = {
            add = "▎",
            change = "▎",
            delete = "▎",
        },
    },
})
