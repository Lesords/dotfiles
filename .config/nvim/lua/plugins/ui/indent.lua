-- mini.indentscope
vim.cmd('hi! link MiniIndentscopeSymbol GruvboxBlue')
require('mini.indentscope').setup({
    symbol = "▎",
})
local disabled_filetypes = { 'help', 'man', 'fern', 'startify', 'copilot-chat', 'codecompanion' }
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('MiniIndentScopeDisable', { clear = true }),
    callback = function(opts)
        local ftype = vim.bo[opts.buf].filetype
        if vim.tbl_contains(disabled_filetypes, ftype) then
            vim.b.miniindentscope_disable = true
        end
    end,
})

-- indent-blankline
require("ibl").setup({
    scope = { enabled = false },
})

local hooks = require "ibl.hooks"
hooks.register(hooks.type.ACTIVE, function(bufnr)
    return vim.tbl_contains(
        { "cpp", "c", "python", "lua", "vim" },
        vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    )
end)
