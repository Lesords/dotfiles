vim.opt.splitright = true

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc
]]

-- vim-lsp
vim.g.lsp_auto_enable = false
vim.keymap.set("n", "<leader>lp", ":call lsp#enable()<CR>", { noremap = true, silent = true })

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

-- Blink Cmp
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828", fg= "#928374" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#282828", fg= "#928374" })

require('blink.cmp').setup({
    keymap = {
        preset = "default",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
    },
    appearance = {
        nerd_font_variant = 'mono'
    },
    completion = {
        ghost_text = { enabled = true },
        menu = {
            border = "rounded",
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = true,
            window = {
                border = 'rounded',
            }
        }
    },
    sources = {
        per_filetype = {
            -- Add the copilot-chat source for relevant filetype
            ["copilot-chat"] = { "copilotchat" },
        },
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            path = {
                -- Path sources triggered by "/" interfere with CopilotChat commands
                enabled = function()
                    return vim.bo.filetype ~= "copilot-chat"
                end,
            },
            copilotchat = {
                name = "CopilotChat",
                module = "blink-cmp-copilot-chat",
            },
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
            },
        },
    },
    fuzzy = {
        implementation = "lua",
    }
})
