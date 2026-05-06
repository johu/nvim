local miniclue = require 'mini.clue'

miniclue.setup {
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },
  clues = {
    { mode = { 'n', 'x' }, keys = '<Leader><Tab>', desc = '+tabs' },
    { mode = { 'n', 'x' }, keys = '<Leader>c', desc = '+code' },
    { mode = { 'n', 'x' }, keys = '<Leader>d', desc = '+debug' },
    { mode = { 'n', 'x' }, keys = '<Leader>dp', desc = '+profiler' },
    { mode = { 'n', 'x' }, keys = '<Leader>e', desc = '+edit' },
    { mode = { 'n', 'x' }, keys = '<Leader>f', desc = '+find' },
    { mode = { 'n', 'x' }, keys = '<Leader>g', desc = '+git' },
    { mode = { 'n', 'x' }, keys = '<Leader>gh', desc = '+hunks' },
    { mode = { 'n', 'x' }, keys = '<Leader>q', desc = '+quit/session' },
    { mode = { 'n', 'x' }, keys = '<Leader>s', desc = '+search' },
    { mode = { 'n', 'x' }, keys = '<Leader>u', desc = '+ui' },
    { mode = { 'n', 'x' }, keys = '<Leader>x', desc = '+diagnostics/quickfix' },
    { mode = 'n', keys = '<Leader>b', desc = '+buffer' },
    { mode = 'n', keys = '<Leader>w', desc = '+windows' },
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 300,
  },
}

require('mini.statusline').setup {
  use_icons = true,
}

require('mini.tabline').setup {
  show_icons = true,
  tabpage_section = 'right',
}
