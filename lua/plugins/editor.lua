local gh = require('vim-pack').gh
local map = vim.keymap.set

-- Search and replace across files with previews and scoped filters.
vim.pack.add {
  { src = gh 'MagicDuck/grug-far.nvim' },
}

require('mini.surround').setup()

require('mini.jump2d').setup {
  mappings = {
    start_jumping = '',
  },
}

map({ 'n', 'x', 'o' }, '<leader>j', function()
  MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end, { desc = 'Jump' })

require('grug-far').setup { headerMaxWidth = 80 }

map({ 'n', 'v' }, '<leader>sr', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e' or nil

  require('grug-far').open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and Replace' })
