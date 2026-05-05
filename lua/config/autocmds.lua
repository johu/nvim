-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- perform updates when plugin changed
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('vim-pack-hooks', { clear = true }),
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

-- markdown
local markdown_augroup = vim.api.nvim_create_augroup('Markdown', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = markdown_augroup,
  pattern = { '*.md' },
  callback = function()
    vim.bo.textwidth = 80
    vim.bo.formatoptions = 'tcqawjp]'
  end,
})
