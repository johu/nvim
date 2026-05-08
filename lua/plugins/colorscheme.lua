local gh = require('vim-pack').gh

vim.pack.add {
  {
    src = gh 'folke/tokyonight.nvim',
  },
}

require('tokyonight').setup { style = 'moon' }
vim.cmd.colorscheme 'tokyonight'
