vim.opt.splitright = true

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc
]]

-- CopilotChat
vim.api.nvim_set_hl(0, 'CopilotChatHeader', { fg = '#7C3AED', bold = true })
vim.api.nvim_set_hl(0, 'CopilotChatSeparator', { fg = '#374151' })

vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>", { noremap = true, silent = true })

require("CopilotChat").setup({
    model = 'claude-sonnet-4.5',
    -- model = "gemini-3-pro-preview",

    highlight_headers = true,
    error_header = '> [!ERROR] Error',
    temperature = 0.1,           -- Lower = focused, higher = creative
    chat_autocomplete = false,

    headers = {
        user = ' ━ 👤 You',
        assistant = ' ━ 🤖 Copilot',
        tool = ' ━ 🔧 Tool',
    },

    window = {
        layout = 'vertical',
        width = 0.4, -- Fixed width in columns
        height = 20, -- Fixed height in rows
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        title = '🤖 AI Assistant',
        zindex = 100, -- Ensure window stays on top
    },

    separator = '━━',
    auto_fold = true, -- Automatically folds non-assistant messages
    auto_insert_mode = false,     -- Enter insert mode when opening
})

vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { fg = "#E39AA6", bg = "#1a190c", bold = true })
require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion', 'copilot-chat' },
    render_modes = { "n", "no", "c", "t", "i", "ic" },
})
