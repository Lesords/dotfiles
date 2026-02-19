-- nvim-treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "markdown", "markdown_inline", "yaml" },
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
