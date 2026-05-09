local map = vim.keymap.set

require('mini.sessions').setup {
  autowrite = true,
}

map('n', '<leader>qs', function()
  MiniSessions.read()
end, { desc = 'Restore Session' })

map('n', '<leader>qS', function()
  MiniSessions.select 'read'
end, { desc = 'Select Session' })

map('n', '<leader>ql', function()
  local latest = MiniSessions.get_latest()
  if latest == nil then
    vim.notify('No saved sessions found', vim.log.levels.INFO)
    return
  end

  MiniSessions.read(latest)
end, { desc = 'Restore Last Session' })

map('n', '<leader>qd', function()
  vim.v.this_session = ''
  vim.notify('Detached current session', vim.log.levels.INFO)
end, { desc = 'Detach Current Session' })
