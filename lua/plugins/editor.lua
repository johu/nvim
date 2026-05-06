require('mini.pairs').setup()

require('mini.surround').setup()

require('mini.jump2d').setup {
  mappings = {
    start_jumping = '',
  },
}

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', function()
  MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end, { desc = 'Jump' })
