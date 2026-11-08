-- Animated LSP progress, shown by ui2 in its message window.
--
-- Each progress token is one `kind = 'progress'` message. Re-echoing a
-- message with the same id updates it in place, so a timer only has to
-- re-send the running ones with the next spinner frame.
local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local interval = 80

---@class config.progress.Task
---@field title string
---@field message? string
---@field percent? integer

---One message per client; concurrent tokens are folded into it.
---@type table<integer, { name: string, tasks: table<string|integer, config.progress.Task>, current: config.progress.Task }>
local running = {}
local frame = 1
local timer = assert(vim.uv.new_timer())

---@param client_id integer
---@param state { name: string, tasks: table, current: config.progress.Task }
---@param status 'running'|'success'
local function show(client_id, state, status)
  -- Core renders "<title>: <percent>% <text>", so the spinner lives in the
  -- title and the text is only the server's message.
  local task = state.current
  local icon = status == 'running' and frames[frame] or '✓'
  local more = vim.tbl_count(state.tasks) - 1
  local text = task.message or ''
  if status == 'running' and more > 0 then
    text = vim.trim(('%s (+%d)'):format(text, more))
  end
  vim.api.nvim_echo({ { text, status == 'running' and 'Normal' or 'DiagnosticOk' } }, false, {
    id = 'lsp.' .. client_id,
    kind = 'progress',
    source = 'vim.lsp',
    title = ('%s %s: %s'):format(icon, state.name, task.title),
    status = status,
    percent = task.percent,
  })
end

local function tick()
  frame = frame % #frames + 1
  for client_id, state in pairs(running) do
    show(client_id, state, 'running')
  end
  if next(running) == nil then
    timer:stop()
  end
end

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Show animated LSP progress',
  group = vim.api.nvim_create_augroup('config.progress', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local token, value = ev.data.params.token, ev.data.params.value
    if not client or type(value) ~= 'table' then
      return
    end

    local state = running[client.id] or { name = client.name, tasks = {} }
    local task = state.tasks[token] or { title = value.title or 'working' }
    task.message, task.percent = value.message, value.percentage
    state.current = task

    if value.kind == 'end' then
      state.tasks[token] = nil
      local _, other = next(state.tasks)
      if other then
        state.current = other
        running[client.id] = state
      else
        running[client.id] = nil
        show(client.id, state, 'success')
      end
      return
    end

    state.tasks[token] = task
    running[client.id] = state
    show(client.id, state, 'running')
    if not timer:is_active() then
      timer:start(interval, interval, vim.schedule_wrap(tick))
    end
  end,
})
