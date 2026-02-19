require('config.basic')

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc
]]

require('plugins.codecompanion.codecompanion')
require('plugins.copilotchat.copilotchat')
require('plugins.lang.nvim-treesitter')
require('plugins.lang.render-markdown')
require('plugins.lsp.vim-lsp')
require('plugins.ui.noice')
require('plugins.ui.indent')
require('plugins.ui.fold')
require('plugins.ui.diff')
require('plugins.utils.blinkcmp')
require('plugins.utils.minipick')
