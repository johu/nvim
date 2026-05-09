local function augroup(name)
  return vim.api.nvim_create_augroup('user-' .. name, { clear = true })
end

-- check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'highlight-yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- perform updates when plugin changed
vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup 'vim-pack-hooks',
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      if not event.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
      return
    end

    if name == 'markdown-preview.nvim' then
      if not event.data.active then
        vim.cmd.packadd 'markdown-preview.nvim'
      end
      vim.fn['mkdp#util#install']()
    end
  end,
})

-- update all plugins
vim.api.nvim_create_user_command('PackUpdate', function(command)
  local names = vim.split(command.args, '%s+', { trimempty = true })
  vim.pack.update(#names > 0 and names or nil, { force = command.bang })
end, {
  bang = true,
  nargs = '*',
})

-- remove plugins from disk that are no longer in vim.pack.add() specs
vim.api.nvim_create_user_command('PackClean', function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()
  if #inactive == 0 then
    vim.notify('No inactive plugins to remove', vim.log.levels.INFO)
    return
  end
  vim.pack.del(inactive)
  vim.notify('Removed: ' .. table.concat(inactive, ', '), vim.log.levels.INFO)
end, { desc = 'Remove plugins not in vim.pack.add() specs' })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup 'resize-splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'man-unlisted',
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close-with-q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap-spell',
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'json-conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto-create-dir',
  callback = function(event)
    if event.match:match '^%w%w+:[/][/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup 'env-filetype',
  pattern = { '*.env', '.env.*' },
  callback = function()
    vim.opt_local.filetype = 'sh'
  end,
})

-- set filetype for .toml files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup 'toml-filetype',
  pattern = { '*.tomg-config*' },
  callback = function()
    vim.opt_local.filetype = 'toml'
  end,
})

-- set filetype for .ejs files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup 'ejs-filetype',
  pattern = { '*.ejs', '*.ejs.t' },
  callback = function()
    vim.opt_local.filetype = 'embedded_template'
  end,
})

-- Set filetype for .code-snippets files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup 'code-snippets-filetype',
  pattern = { '*.code-snippets' },
  callback = function()
    vim.opt_local.filetype = 'json'
  end,
})

-- markdown
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup 'markdown',
  pattern = { '*.md' },
  callback = function()
    vim.bo.textwidth = 80
    vim.bo.formatoptions = 'tcqawjp]'
  end,
})
