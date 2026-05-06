require('mini.sessions').setup {
  autowrite = true,
}

vim.keymap.set('n', '<leader>qs', function()
  MiniSessions.read()
end, { desc = 'Restore Session' })

vim.keymap.set('n', '<leader>qS', function()
  MiniSessions.select 'read'
end, { desc = 'Select Session' })

vim.keymap.set('n', '<leader>ql', function()
  local latest = MiniSessions.get_latest()
  if latest == nil then
    vim.notify('No saved sessions found', vim.log.levels.INFO)
    return
  end

  MiniSessions.read(latest)
end, { desc = 'Restore Last Session' })

vim.keymap.set('n', '<leader>qd', function()
  vim.v.this_session = ''
  vim.notify('Detached current session', vim.log.levels.INFO)
end, { desc = 'Detach Current Session' })
