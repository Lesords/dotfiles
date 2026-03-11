local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Telescope search current word" })
vim.keymap.set('n', '<leader>fl', builtin.current_buffer_fuzzy_find, { desc = "Telecope search curent buffer" })

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<C-d>"] = actions.results_scrolling_down,
                ["<C-u>"] = actions.results_scrolling_up,
                ["<C-j>"] = actions.preview_scrolling_down,
                ["<C-k>"] = actions.preview_scrolling_up,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
            },
            n = {
                ["<C-c>"] = actions.close,
                ["<C-d>"] = actions.results_scrolling_down,
                ["<C-u>"] = actions.results_scrolling_up,
                ["<C-j>"] = actions.preview_scrolling_down,
                ["<C-k>"] = actions.preview_scrolling_up,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
            }
        },
    },
})
