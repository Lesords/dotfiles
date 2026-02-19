-- CopilotChat
vim.api.nvim_set_hl(0, 'CopilotChatHeader', { fg = '#7C3AED', bold = true })
vim.api.nvim_set_hl(0, 'CopilotChatSeparator', { fg = '#374151' })

vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-chat",
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = true
        vim.opt_local.signcolumn = "no"
    end,
})

require("CopilotChat").setup({
    -- model = 'gpt-4o',
    model = 'claude-sonnet-4.5',
    -- model = "gemini-3-pro-preview",

    highlight_headers = false,
    error_header = '> [!ERROR] Error',
    temperature = 0.1,           -- Lower = focused, higher = creative
    chat_autocomplete = false,

    headers = {
        user = ' You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
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
