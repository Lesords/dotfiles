vim.keymap.set('n', '<M-u>', '<cmd>Outline<CR>', { silent = true, desc = 'Toggle outline' })

require('outline').setup({
  outline_window = {
    width = 22,
    show_cursorline = 'focus_in_outline',
    focus_on_open = true,
  },
  outline_items = {
    show_symbol_details = false,
    show_symbol_lineno = true,
  },
  guides = {
    enabled = true,
    markers = {
      bottom = '└',
      middle = '├',
      vertical = '│',
      horizontal = '─',
    },
  },
  preview_window = {
    auto_preview = false,
    open_hover_on_preview = false,
    border = 'rounded',
    winhl = 'Normal:NormalFloat,FloatBorder:FloatBorder',
  },
})

vim.api.nvim_set_hl(0, 'OutlineGuides', { fg = '#665c54' })
vim.api.nvim_set_hl(0, 'OutlineFoldMarker', { fg = '#928374' })
vim.api.nvim_set_hl(0, 'OutlineLineno', { fg = '#7c6f64' })
vim.api.nvim_set_hl(0, 'OutlineCurrent', { fg = '#ebdbb2', bg = '#3c3836', bold = true })
