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

-- tab/shift-tab: like browser tabs, feels natural
map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })

map('n', '<leader><tab><tab>', '<cmd>tabnew<CR>', { desc = 'New Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<CR>', { desc = 'Close Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<CR>', { desc = 'First Tab' })
map('n', '<leader><tab>j', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<leader><tab>k', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<leader><tab>l', '<cmd>tablast<CR>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<CR>', { desc = 'Close Other Tabs' })

-- smart j/k: moves by visual lines when no count, real lines with count
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- move lines up/down (Alt+j/k like VSCode)
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- alternative line movement
map('v', 'J', "<cmd>m '>+1<CR>gv=gv", { desc = 'Move lines down in visual selection' })
map('v', 'K', "<cmd>m '<-2<CR>gv=gv", { desc = 'Move lines up in visual selection' })

-- better line start/end (more comfortable than $ and ^)
map('n', 'gl', '$', { desc = 'Go to end of line' })
map('n', 'gh', '^', { desc = 'Go to start of line' })
map('n', '<A-h>', '^', { desc = 'Go to start of line', silent = true })
map('n', '<A-l>', '$', { desc = 'Go to end of line', silent = true })

-- select all content
map('n', '==', 'gg<S-v>G')
map('n', '<A-a>', 'ggVG', { noremap = true, silent = true, desc = 'Select all' })

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

-- copy whole file to clipboard
map('n', '<C-c>', ':%y+<CR>', opts)

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

-- commenting (add comment above/below current line)
map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- quickfix and location lists
map('n', '<leader>xl', function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Location List' })

map('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- inspection tools (useful for debugging highlights and treesitter)
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
map('n', '<leader>uI', '<cmd>InspectTree<cr>', { desc = 'Inspect Tree' })

-- keyword program (K for help on word under cursor)
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- toggle line wrapping
map('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = 'Toggle Wrap', silent = true })

-- fix spelling (picks first suggestion)
map('n', 'z0', '1z=', { desc = 'Fix word under cursor' })

-- built-in UI and history
map('n', '<leader>uc', ui.open_command_line_window, { desc = 'Command-line Window' })
map('n', '<leader>uh', ui.show_undo_history, { desc = 'Undo History' })
map('n', '<leader>um', ui.show_messages, { desc = 'Message History' })
map('n', '<leader>ut', function()
  require('undotree').open()
end, { desc = 'Open Undo Tree' })
map('n', '[u', 'g-', { desc = 'Older Text State' })
map('n', ']u', 'g+', { desc = 'Newer Text State' })
