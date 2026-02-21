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
        -- 自定义 mini 视图，用于 LSP 进度通知
        mini = {
            backend = "mini",
            relative = "editor",
            align = "message-right",
            timeout = 2000,
            reverse = true,
            focusable = false,
            position = {
                row = -2,
                col = "100%",
            },
            size = {
                width = "auto",
                height = "auto",
                max_height = 10,
            },
            border = {
                style = "rounded",
                padding = { 0, 1 },
            },
            zindex = 60,
            win_options = {
                winbar = "",
                foldenable = false,
                winblend = 30,
                winhighlight = {
                    Normal = "NoiceMini",
                    IncSearch = "",
                    CurSearch = "",
                    Search = "",
                    FloatBorder = "NoiceMiniBorder",
                },
            },
        },
    },
    lsp = {
        progress = {
            view = "mini",
        },
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
