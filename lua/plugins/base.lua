vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'main' },
}

require('mini.icons').setup {
  file = {
    ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
  },
  filetype = {
    dotenv = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
