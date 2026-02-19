vim.opt.splitright = true
vim.opt.termguicolors = true

if vim.env.WSL_DISTRO_NAME then
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_clipboard_provider = 1
end
