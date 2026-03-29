vim.cmd [[
    let mapleader    = ","

    call plug#begin('~/.config/nvim/plugged')
        Plug 'morhetz/gruvbox'
        Plug 'preservim/vim-indent-guides'
        Plug 'luochen1990/rainbow'
        Plug 'itchyny/lightline.vim'

        Plug 'tpope/vim-obsession'
        Plug 'mhinz/vim-signify', { 'on': ['SignifyToggle', 'SignifyDiff', 'SignifyHunkDiff', 'SignifyHunkUndo'] }
        Plug 'tpope/vim-surround'
        Plug 'wellle/context.vim'
        Plug 'jiangmiao/auto-pairs'
        Plug 'tpope/vim-commentary'
        Plug 'mg979/vim-visual-multi'
        Plug 'terryma/vim-expand-region'
        Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-overwin-f2)', '<Plug>(easymotion-sn)', '<Plug>(easymotion-tn)', '<Plug>(easymotion-j)', '<Plug>(easymotion-k)'] }
        Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
        Plug 'rhysd/vim-clang-format'
        Plug 'tpope/vim-fugitive'

        Plug 'lambdalisue/fern.vim', { 'on': 'Fern' }
        Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'on': 'Fern' }
        Plug 'lambdalisue/nerdfont.vim'
        Plug 'lambdalisue/glyph-palette.vim'
        Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
        Plug 'voldikss/vim-floaterm', { 'on': ['FloatermToggle', 'FloatermNew', 'FloatermPrev', 'FloatermNext', 'FloatermUpdate'] }

        if !exists('$MSYSTEM')
            Plug 'mhinz/vim-startify'
            Plug 'liuchengxu/vista.vim', { 'on': 'Vista!!' }
            Plug 'christoomey/vim-tmux-navigator'
        endif

        Plug 'nvim-lua/plenary.nvim',
        Plug 'CopilotC-Nvim/CopilotChat.nvim',
        Plug 'olimorris/codecompanion.nvim',
        Plug 'ravitemer/codecompanion-history.nvim',
        Plug 'franco-ruggeri/codecompanion-spinner.nvim',

        Plug 'saghen/blink.cmp',                            { 'tag': 'v1.*' }
        Plug 'fang2hou/blink-copilot',
        Plug 'pxwg/blink-cmp-copilot-chat',
        Plug 'zbirenbaum/copilot.lua',

        Plug 'kevinhwang91/nvim-ufo',
        Plug 'kevinhwang91/promise-async',
        Plug 'lukas-reineke/indent-blankline.nvim',

        Plug 'hedyhli/outline.nvim',

        Plug 'nvim-treesitter/nvim-treesitter',             { 'branch': 'master', 'do': ':TSUpdate' }
        Plug 'MeanderingProgrammer/render-markdown.nvim',
        " Used by render-markdown.nvim
        Plug 'nvim-mini/mini.nvim',

        Plug 'folke/noice.nvim',
        Plug 'rcarriga/nvim-notify',
        Plug 'MunifTanjim/nui.nvim',
        Plug 'nvim-telescope/telescope.nvim',

        Plug 'yetone/avante.nvim',                          { 'branch': 'main', 'do': 'make' }
    call plug#end()

    source ~/.vim/config/lang.vim
    source ~/.vim/config/motion.vim
    source ~/.vim/config/ui.vim
    source ~/.vim/config/util.vim
    source ~/.vim/config/plugins/fern.vim
    source ~/.vim/config/plugins/lightline.vim
    source ~/.vim/config/plugins/startify.vim
    source ~/.vim/config/plugins/vim-floaterm.vim
]]
