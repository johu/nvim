local M = {}

local function command_output(command)
  local output = vim.api.nvim_exec2(command, { output = true }).output
  return vim.split(output, '\n', { trimempty = true })
end

local function open_scratch(title, lines)
  local content = vim.deepcopy(lines)

  if #content == 0 then
    content = { 'No entries available.' }
  end

  vim.cmd 'botright new'

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = 'log'

  vim.api.nvim_buf_set_name(buf, title)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.bo[buf].modifiable = false

  vim.api.nvim_win_set_height(win, math.min(math.max(#content, 8), 18))
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
end

function M.show_messages()
  open_scratch('Messages', command_output 'messages')
end

function M.show_undo_history()
  open_scratch('Undo History', command_output 'undolist')
end

function M.open_command_line_window()
  vim.cmd 'q:'
end

return M
