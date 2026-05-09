-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local ui = require 'config.ui'
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', 'x', '"_x') -- delete without saving in buffer
map('n', '<ESC>', '<cmd>nohlsearch<CR>')
map('n', '<leader>cx', '<cmd>source %<CR>', { desc = 'Source File' })

-- plugin manager
map('n', '<leader>pu', '<cmd>PackUpdate<CR>', { desc = 'Update Plugins' })
map('n', '<leader>pc', '<cmd>PackClean<CR>', { desc = 'Cleanup Plugins' })

-- numbers
map('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
map('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- window management
map('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
map('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
map('n', '<leader>we', '<C-w>=', { desc = 'Make splits equal size' })
map('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Close current split' })

map('n', '<leader><tab><tab>', '<cmd>tabnew<CR>', { desc = 'New Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<CR>', { desc = 'Close Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<CR>', { desc = 'First Tab' })
map('n', '<leader><tab>j', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<leader><tab>k', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<leader><tab>l', '<cmd>tablast<CR>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<CR>', { desc = 'Close Other Tabs' })

-- move visual selection
map('v', 'J', "<cmd>m '>+1<CR>gv=gv", { desc = 'Move lines down in visual selection' })
map('v', 'K', "<cmd>m '<-2<CR>gv=gv", { desc = 'Move lines up in visual selection' })

-- remaps for centering
map('n', '<C-d>', '<C-d>zz', { desc = 'Move down in buffer with cursor centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Move up in buffer with cursor centered' })
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')

-- indent visual selection
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- remap for keeping yank content after paste
map('x', '<leader>p', [["_dP]])
map('v', 'p', '"_dp', opts)

-- copies or yank to system clipboard
map('n', '<leader>Y', [["+Y]], opts)

-- leader d delete wont remember as yanked/clipboard when delete pasting
map({ 'n', 'v' }, '<leader>d', [["_d]])

-- auto close pairs
-- map("i", "'", "''<left>") -- commented out - smart!
map('i', '`', '``<left>')
map('i', '"', '""<left>')
map('i', '(', '()<left>')
map('i', '[', '[]<left>')
map('i', '{', '{}<left>')
map('i', '<', '<><left>')

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- built-in UI and history
map('n', '<leader>uc', ui.open_command_line_window, { desc = 'Command-line Window' })
map('n', '<leader>uh', ui.show_undo_history, { desc = 'Undo History' })
map('n', '<leader>um', ui.show_messages, { desc = 'Message History' })
map('n', '<leader>ut', function()
  require('undotree').open()
end, { desc = 'Open Undo Tree' })
map('n', '[u', 'g-', { desc = 'Older Text State' })
map('n', ']u', 'g+', { desc = 'Newer Text State' })
