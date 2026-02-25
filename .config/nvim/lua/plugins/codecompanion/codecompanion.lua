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
                        provider = "telescope", -- min_pick
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
        action_palette = {
            provider = "default", -- or "telescope", "mini_pick", "snacks"
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
        history = {
            enabled = true,
            opts = {
                -- Keymap to open history from chat buffer (default: gh)
                -- keymap = "<C-h>",
                keymap = "gh",
                -- Keymap to save the current chat manually (when auto_save is disabled)
                save_chat_keymap = "sc",
                -- Save all chats by default (disable to save only manually using 'sc')
                auto_save = true,
                -- Number of days after which chats are automatically deleted (0 to disable)
                expiration_days = 0,
                -- Picker interface (auto resolved to a valid picker)
                picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
                ---Optional filter function to control which chats are shown when browsing
                chat_filter = nil, -- function(chat_data) return boolean end
                -- Customize picker keymaps (optional)
                picker_keymaps = {
                    rename = { n = "r", i = "<M-r>" },
                    delete = { n = "d", i = "<M-d>" },
                    duplicate = { n = "<C-y>", i = "<C-y>" },
                },
                ---Automatically generate titles for new chats
                auto_generate_title = true,
                title_generation_opts = {
                    ---Adapter for generating titles (defaults to current chat adapter)
                    adapter = nil, -- "copilot"
                    ---Model for generating titles (defaults to current chat model)
                    model = nil, -- "gpt-4o"
                    ---Number of user prompts after which to refresh the title (0 to disable)
                    refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                    ---Maximum number of times to refresh the title (default: 3)
                    max_refreshes = 3,
                    format_title = function(original_title)
                        -- this can be a custom function that applies some custom
                        -- formatting to the title.
                        return original_title
                    end
                },
                ---On exiting and entering neovim, loads the last chat on opening chat
                continue_last_chat = false,
                ---When chat is cleared with `gx` delete the chat from history
                delete_on_clearing_chat = false,
                ---Directory path to save the chats
                dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                ---Enable detailed logging for history extension
                enable_logging = false,

                -- Summary system
                summary = {
                    -- Keymap to generate summary for current chat (default: "gcs")
                    create_summary_keymap = "gcs",
                    -- Keymap to browse summaries (default: "gbs")
                    browse_summaries_keymap = "gbs",

                    generation_opts = {
                        adapter = nil, -- defaults to current chat adapter
                        model = nil, -- defaults to current chat model
                        context_size = 90000, -- max tokens that the model supports
                        include_references = true, -- include slash command content
                        include_tool_outputs = true, -- include tool execution results
                        system_prompt = nil, -- custom system prompt (string or function)
                        format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
                    },
                },

                -- Memory system (requires VectorCode CLI)
                memory = {
                    -- Automatically index summaries when they are generated
                    auto_create_memories_on_summary_generation = true,
                    -- Path to the VectorCode executable
                    vectorcode_exe = "vectorcode",
                    -- Tool configuration
                    tool_opts = {
                        -- Default number of memories to retrieve
                        default_num = 10
                    },
                    -- Enable notifications for indexing progress
                    notify = true,
                    -- Index all existing memories on startup
                    -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
                    index_on_startup = false,
                },
            }
        },
        spinner = {},
    },
})
