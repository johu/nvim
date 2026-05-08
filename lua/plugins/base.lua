local gh = require('vim-pack').gh

vim.pack.add {
  { src = gh 'nvim-lua/plenary.nvim' },
  { src = gh 'nvim-mini/mini.nvim', version = 'main' },
}

require('mini.icons').setup {
  file = {
    ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
  },
  filetype = {
    dotenv = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
