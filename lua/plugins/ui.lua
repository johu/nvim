local gh = require('vim-pack').gh

-- Dashboard and a slimmer cmdline are worth the extra dependencies.
vim.pack.add {
  { src = gh 'folke/snacks.nvim' },
  {
    src = gh 'rachartier/tiny-cmdline.nvim',
    config = function()
      vim.o.cmdheight = 0
      local tiny_cmdline = require 'tiny-cmdline'
      tiny_cmdline.setup {
        on_reposition = tiny_cmdline.adapters.blink,
      }
    end,
  },
}

require('mini.notify').setup {}

local function dashboard_startup_section()
  local started = vim.g.config_start_time or vim.uv.hrtime()
  local elapsed_ms = (vim.uv.hrtime() - started) / 1e6
  local stats = { loaded = 0, count = 0 }

  local ok, plugins = pcall(vim.pack.get, nil, { info = false })
  if ok then
    stats.loaded = #plugins
    stats.count = #plugins
  end

  return {
    align = 'center',
    text = {
      { '⚡ Neovim loaded ', hl = 'footer' },
      { ('%d/%d'):format(stats.loaded, stats.count), hl = 'special' },
      { ' plugins in ', hl = 'footer' },
      { ('%.2fms'):format(elapsed_ms), hl = 'special' },
    },
  }
end

require('snacks').setup {
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = "<cmd>lua require('fzf-lua').files()<cr>" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = "<cmd>lua require('fzf-lua').live_grep()<cr>" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = "<cmd>lua require('fzf-lua').oldfiles()<cr>" },
        { icon = ' ', key = 'c', desc = 'Config', action = "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })<cr>" },
        { icon = ' ', key = 's', desc = 'Restore Session', action = '<cmd>lua MiniSessions.read()<cr>' },
        { icon = '󰏔 ', key = 'p', desc = 'Plugins', action = ':PackUpdate' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      {
        pane = 1,
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        dashboard_startup_section,
      },
    },
  },
}

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

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

require('mini.tabline').setup {
  show_icons = true,
  tabpage_section = 'right',
}
