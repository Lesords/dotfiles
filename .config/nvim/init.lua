vim.opt.splitright = true
vim.opt.termguicolors = true

if vim.env.WSL_DISTRO_NAME then
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_clipboard_provider = 1
end

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc
]]

-- vim-lsp
vim.g.lsp_auto_enable = false
vim.keymap.set("n", "<leader>lp", ":call lsp#enable()<CR>", { noremap = true, silent = true })

-- mini.pick
require('mini.pick').setup()
vim.ui.select = require('mini.pick').ui_select
vim.keymap.set("n", "<space>ff", ":Pick files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>fs", ":Pick grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>fl", ":Pick grep_live<CR>", { noremap = true, silent = true })

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
    model = 'claude-sonnet-4.5',
    -- model = "gemini-3-pro-preview",

    highlight_headers = false,
    error_header = '> [!ERROR] Error',
    temperature = 0.1,           -- Lower = focused, higher = creative
    chat_autocomplete = false,

    headers = {
        user = '👤 You',
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

-- mini.indentscope
vim.cmd('hi! link MiniIndentscopeSymbol GruvboxBlue')
require('mini.indentscope').setup({
    symbol = "│",
})
local disabled_filetypes = { 'help', 'man', 'fern', 'startify', 'copilot-chat' }
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('MiniIndentScopeDisable', { clear = true }),
    callback = function(opts)
        local ftype = vim.bo[opts.buf].filetype
        if vim.tbl_contains(disabled_filetypes, ftype) then
            vim.b.miniindentscope_disable = true
        end
    end,
})

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

-- codecompanion
vim.keymap.set({ "n", "v" }, "<space>a", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<space>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
require("codecompanion").setup({
    interactions = {
        chat = {
            -- You can specify an adapter by name and model (both ACP and HTTP)
            adapter = {
                name = "copilot",
                model = "gemini-3-pro-preview",
            },
            roles = {
                llm = function(adapter)
                    local model_name = ''
                    if adapter.schema and adapter.schema.model and adapter.schema.model.default then
                        local model = adapter.schema.model.default
                        if type(model) == 'function' then
                            model = model(adapter)
                        end
                        model_name = '(' .. model .. ')'
                    end
                    return '🤖 ' .. adapter.formatted_name .. model_name
                end,
                user = ' User',
            },
            keymaps = {
                stop = {
                    modes = {
                        n = "q",
                        i = "<C-q>",
                    },
                },
            },
            slash_commands = {
                ["file"] = {
                    keymaps = {
                        modes = {
                            i = "<C-f>",
                            n = { "<C-f>", "gf" },
                        },
                    },
                    opts = {
                        provider = "mini_pick",
                    },
                },
            },
            opts = {
                prompt_decorator = function(message, adapter, context)
                    return string.format([[<prompt>%s</prompt>]], message)
                end,
            },
        },
        inline = {
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                },
                reject_change = {
                    modes = { n = "gr" },
                },
                always_accept = {
                    modes = { n = "gA" },
                },
            },
        },
    },
    display = {
        chat = {
            show_header_separator = true,
        },
        diff = {
            enabled = true,
            provider = mini_diff, -- inline|split|mini_diff
        },
    },
    prompt_library = {
        ["Explain Code"] = {
            interaction = "chat",
            description = "Explain how code works",
            prompts = {
                {
                    role = "system",
                    content = "You are an expert programmer who excels at explaining code clearly and concisely.",
                },
                {
                    role = "user",
                    content = function(context)
                        local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                        return "Please explain the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```"
                    end,
                },
            },
        },
    },
    opts = {
        log_level = "DEBUG",
        language = "Chinese",
    },
    extensions = {
        spinner = {},
    },
})

-- nvim-ufo
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
local ftMap = {
    vim = 'indent',
    python = {'indent'},
    git = ''
}
require('ufo').setup({
    open_fold_hl_timeout = 100,
    close_fold_kinds_for_ft = {
        default = {'imports', 'comment'},
        json = {'array'},
        c = {'comment', 'region'}
    },
    close_fold_current_line_for_ft = {
        default = true,
        c = false
    },
    preview = {
        win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
        }
    },
    provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype]
    end
})
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

require("noice").setup({
    views = {
        cmdline_popup = {
            backend = 'popup',
            relative = 'editor',
            zindex = 200,
            position = {
                row = '40%',
                col = '50%',
            },
            size = {
                width  = 'auto',
                height = 'auto',
            },
            win_options = {
                winhighlight = {
                    Normal      = 'NoiceCmdlinePopup',
                    FloatTitle  = 'NoiceCmdlinePopupTitle',
                    FloatBorder = 'NoiceCmdlinePopupBorder',
                    IncSearch   = '',
                    CurSearch   = '',
                    Search      = '',
                },
                winbar     = '',
                foldenable = false,
                cursorline = false,
            },
        },
    },
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search         = true, -- use a classic bottom cmdline for search
        command_palette       = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename            = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border        = false, -- add a border to hover docs and signature help
    },
    cmdline = {
        view = 'cmdline_popup',
    },
})
