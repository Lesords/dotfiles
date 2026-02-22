-- codecompanion
vim.keymap.set({ "n", "v" }, "<space>a", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<space>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

vim.api.nvim_create_autocmd("FileType", {
    pattern = "codecompanion",
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
    end,
})

require("plugins.codecompanion.notification").init()
require('plugins.codecompanion.extmarks').setup()
require("codecompanion").setup({
    interactions = {
        chat = {
            -- You can specify an adapter by name and model (both ACP and HTTP)
            adapter = {
                name = "copilot",
                -- model = "gemini-3-pro-preview",
                model = "gpt-4o",
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
                user = ' User',
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
        markdown = {
            dirs = {
                vim.fn.stdpath('config') .. '/lua/plugins/codecompanion/prompts',
            },
        },
        ["Spell"] = {
            interaction = "inline",
            description = "Correct grammar and reformulate",
            opts = {
                is_default = false,
                alias = "spell",
                is_slash_cmd = true,
                auto_submit = true,
                modes = { "v" },
                adapter = {
                    name = "copilot",
                    model = "gpt-4.1",
                },
            },
            prompts = {
                {
                    role = "user",
                    content = function(context)
                        return "Correct grammar and reformulate:\n\n" .. context.code .. "\n"
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
