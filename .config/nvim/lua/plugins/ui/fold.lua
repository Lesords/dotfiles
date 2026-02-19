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
