-- Blink Copilot
require('blink-copilot').setup({
    debounce = 50,
})

-- Blink Cmp
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828", fg= "#928374" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#282828", fg= "#928374" })

require('blink.cmp').setup({
    keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "fallback" },
        ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
    },
    cmdline = {
        enabled = true,
        completion = { menu = { auto_show = true } },
        keymap = {
            preset = "cmdline",
            ["<Tab>"] = { "accept", "fallback" },
            ["<CR>"] = { "select_accept_and_enter", "fallback" },
        },
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
            auto_show_delay_ms = 100,
            treesitter_highlighting = true,
            window = {
                border = 'rounded',
            }
        }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        per_filetype = {
            -- Add the copilot-chat source for relevant filetype
            ["copilot-chat"] = { "copilotchat" },
        },
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
