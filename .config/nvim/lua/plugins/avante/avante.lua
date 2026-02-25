vim.opt.laststatus = 3

require('avante').setup({
    provider = "copilot",
    providers = {
        copilot = {
            model = "gpt-4o",
        },
    },
    behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
    },
    ui = {
        chat = {
            show_header_separator = true,
            border = "rounded",
        },
        diff = {
            enabled = true,
            auto_jump = true,
        },
        suggestion = {
            enabled = true,
        },
    },
    mappings = {
        ask = "<leader>aa",      -- 打开询问面板
        edit = "<leader>ae",     -- 打开编辑面板
        refresh = "<leader>ar",  -- 刷新
    },
    input = {
        provider = "native", -- "native" | "dressing" | "snacks"
    },
    file_selector = {
        provider = "telescope",
    },
})

vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>AvanteAsk<cr>", { noremap = true, silent = true, desc = "Avante Ask" })
vim.keymap.set({ "n", "v" }, "<leader>ae", "<cmd>AvanteEdit<cr>", { noremap = true, silent = true, desc = "Avante Edit" })
vim.keymap.set("n", "<leader>ar", "<cmd>AvanteRefresh<cr>", { noremap = true, silent = true, desc = "Avante Refresh" })
