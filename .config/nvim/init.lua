-- 在 init.lua 最前面添加，禁用不需要的 provider
vim.g.loaded_python3_provider = 0  -- 禁用 Python3 (节省 ~800ms)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_clipboard_provider = 1  -- 👈 添加这行，阻止 provider 加载

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc
]]

require("codecompanion").setup({
    opts = {
        log_level = "DEBUG", -- or "TRACE"
    }
})

require('blink.cmp').setup({
    keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
    },
    cmdline = { sources = { "cmdline" } },
    appearance = {
        nerd_font_variant = 'mono'
    },
    completion = {
        documentation = { auto_show = false }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = {
        implementation = "lua",
    }
})

require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion' },
})
