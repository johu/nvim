local gh = require('vim-pack').gh
local map = vim.keymap.set

vim.pack.add {
  { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
  { src = gh 'stevearc/oil.nvim' },
  { src = gh 'ibhagwan/fzf-lua' },
}

local harpoon = require 'harpoon'
harpoon:setup {
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
}

require('oil').setup {
  view_options = {
    show_hidden = true,
  },
}

require('fzf-lua').setup {}

map('n', '<leader>H', function()
  harpoon:list():add()
end, { desc = 'Harpoon File' })

map('n', '<leader>h', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon Quick Menu' })

for index, shortcut in ipairs { 'h', 'j', 'k', 'l' } do
  map('n', '<A-' .. shortcut .. '>', function()
    harpoon:list():select(index)
  end, { desc = 'Harpoon to File ' .. index })
end

map('n', '-', require('oil').open, { desc = 'Open file explorer' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config-fzf-terminal-keys', { clear = true }),
  pattern = 'fzf',
  callback = function(event)
    map('t', '<c-j>', '<c-j>', { buffer = event.buf, nowait = true })
    map('t', '<c-k>', '<c-k>', { buffer = event.buf, nowait = true })
  end,
})

local fzf = require 'fzf-lua'

map('n', '<leader>fb', function()
  fzf.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>ff', function()
  fzf.files()
end, { desc = 'Files' })
map('n', '<leader>fg', function()
  fzf.git_files()
end, { desc = 'Git Files' })
map('n', '<leader>fk', function()
  fzf.keymaps()
end, { desc = 'Keymaps' })
map('n', '<leader>fh', function()
  fzf.helptags()
end, { desc = 'Help' })
map('n', '<leader>fr', function()
  fzf.oldfiles()
end, { desc = 'Recent' })
map('n', '<leader>fu', function()
  fzf.builtin()
end, { desc = 'Builtin' })
map('n', '<leader>sb', function()
  fzf.lgrep_curbuf()
end, { desc = 'Buffer' })
map('n', '<leader>sg', function()
  fzf.live_grep()
end, { desc = 'Grep' })
map('n', '<leader>sw', function()
  fzf.grep_cword()
end, { desc = 'Current Word' })
map('n', '<leader>sW', function()
  fzf.grep_cWORD()
end, { desc = 'Current WORD' })
map('n', '<leader>sd', function()
  fzf.diagnostics_document()
end, { desc = 'Diagnostics' })
map('n', '<leader>sD', function()
  fzf.diagnostics_workspace()
end, { desc = 'Diagnostics (Workspace)' })
map('n', '<leader>sR', function()
  fzf.resume()
end, { desc = 'Resume' })
map('n', '<leader>gc', function()
  fzf.git_commits()
end, { desc = 'Commits' })
map('n', '<leader>gs', function()
  fzf.git_status()
end, { desc = 'Status' })
map('n', '<leader>ec', function()
  fzf.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Neovim Config' })
map('n', '<leader>ep', function()
  fzf.files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'pack', 'core', 'start') }
end, { desc = 'Packages' })
map('n', '<leader>/', function()
  fzf.live_grep()
end, { desc = '[/] Grep' })
map('n', '<leader>,', function()
  fzf.buffers { sort_mru = true, sort_lastused = true }
end, { desc = 'Switch Buffer' })
map('n', '<leader>:', function()
  fzf.command_history()
end, { desc = 'Command History' })
map('n', '<leader><leader>', function()
  fzf.files()
end, { desc = 'Find Files' })

map('n', '<leader>st', function()
  fzf.live_grep { search = 'TODO|FIX|FIXME' }
end, { desc = 'Todo/Fix/Fixme' })
