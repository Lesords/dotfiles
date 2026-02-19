vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { fg = "#E39AA6", bg = "#1a190c", bold = true })
require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion', 'copilot-chat' },
    render_modes = { "n", "no", "c", "t", "i", "ic" },
})
