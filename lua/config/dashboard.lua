local M = {}

local dashboard_group = vim.api.nvim_create_augroup('config-native-dashboard', { clear = true })
local dashboard_ns = vim.api.nvim_create_namespace 'config-native-dashboard'
local open_help_float

local dashboard_shortcuts = {
  {
    key = 'f',
    icon = '',
    desc = 'Find File',
    action = function()
      require('fzf-lua').files()
    end,
  },
  {
    key = 'n',
    icon = '',
    desc = 'New File',
    action = function()
      vim.cmd.enew()
      vim.cmd.startinsert()
    end,
  },
  {
    key = 'g',
    icon = '',
    desc = 'Find Text',
    action = function()
      require('fzf-lua').live_grep()
    end,
  },
  {
    key = 'c',
    icon = '',
    desc = 'Config',
    action = function()
      require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
    end,
  },
  {
    key = 's',
    icon = '',
    desc = 'Restore Session',
    action = function()
      MiniSessions.read()
    end,
  },
  {
    key = 'p',
    icon = '󰏔',
    desc = 'Plugins',
    action = function()
      vim.cmd.PackUpdate()
    end,
  },
  {
    key = 'N',
    icon = '',
    desc = 'News',
    action = function()
      open_help_float 'news'
    end,
  },
  {
    key = 'q',
    icon = '',
    desc = 'Quit',
    action = function()
      vim.cmd.qa()
    end,
  },
}

local function nvim_version_label()
  local version = vim.version()
  return ('NVIM v%d.%d.%d'):format(version.major, version.minor, version.patch)
end

local function dashboard_banner_lines()
  return {
    '│ ╲ ││',
    '││╲╲││',
    '││ ╲ │',
    '',
    nvim_version_label(),
  }
end

local function startup_stats_line()
  local started = vim.g.config_start_time or vim.uv.hrtime()
  local elapsed_ms = (vim.uv.hrtime() - started) / 1e6
  local stats = { loaded = 0, count = 0 }

  local ok, plugins = pcall(vim.pack.get, nil, { info = false })
  if ok then
    stats.loaded = #plugins
    stats.count = #plugins
  end

  return ('⚡ Neovim loaded %d/%d plugins in %.2fms'):format(stats.loaded, stats.count, elapsed_ms)
end

local function center_text(text, width)
  local padding = math.max(0, math.floor((width - vim.fn.strdisplaywidth(text)) / 2))
  return string.rep(' ', padding) .. text
end

local function centered_line(text, width)
  local line = center_text(text, width)
  return line, #line - #text
end

open_help_float = function(subject)
  local width = math.min(math.max(80, math.floor(vim.o.columns * 0.8)), vim.o.columns - 4)
  local height = math.min(math.max(20, math.floor(vim.o.lines * 0.8)), vim.o.lines - 4)
  local ok, err = pcall(vim.cmd.help, subject)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local help_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_config(help_win, {
    relative = 'editor',
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
    width = width,
    height = height,
    border = 'rounded',
    style = 'minimal',
  })

  local help_buf = vim.api.nvim_get_current_buf()
  vim.bo[help_buf].bufhidden = 'wipe'
  vim.bo[help_buf].buflisted = false
end

local function is_startup_buffer(bufnr)
  if #vim.api.nvim_list_uis() == 0 or vim.fn.argc() > 0 then
    return false
  end

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if vim.bo[bufnr].modified or vim.bo[bufnr].buftype ~= '' then
    return false
  end

  if vim.api.nvim_buf_get_name(bufnr) ~= '' or vim.api.nvim_buf_line_count(bufnr) ~= 1 then
    return false
  end

  local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  return first_line == ''
end

local function set_dashboard_window_options(winid)
  if vim.w[winid].dashboard_saved_window_options == nil then
    vim.w[winid].dashboard_saved_window_options = {
      colorcolumn = vim.api.nvim_get_option_value('colorcolumn', { win = winid }),
      cursorcolumn = vim.api.nvim_get_option_value('cursorcolumn', { win = winid }),
      cursorline = vim.api.nvim_get_option_value('cursorline', { win = winid }),
      foldcolumn = vim.api.nvim_get_option_value('foldcolumn', { win = winid }),
      foldmethod = vim.api.nvim_get_option_value('foldmethod', { win = winid }),
      list = vim.api.nvim_get_option_value('list', { win = winid }),
      number = vim.api.nvim_get_option_value('number', { win = winid }),
      relativenumber = vim.api.nvim_get_option_value('relativenumber', { win = winid }),
      signcolumn = vim.api.nvim_get_option_value('signcolumn', { win = winid }),
      sidescrolloff = vim.api.nvim_get_option_value('sidescrolloff', { win = winid }),
      spell = vim.api.nvim_get_option_value('spell', { win = winid }),
      statuscolumn = vim.api.nvim_get_option_value('statuscolumn', { win = winid }),
      wrap = vim.api.nvim_get_option_value('wrap', { win = winid }),
    }
  end

  local dashboard_window_options = {
    colorcolumn = '',
    cursorcolumn = false,
    cursorline = false,
    foldcolumn = '0',
    foldmethod = 'manual',
    list = false,
    number = false,
    relativenumber = false,
    signcolumn = 'no',
    sidescrolloff = 0,
    spell = false,
    statuscolumn = '',
    wrap = false,
  }

  for option, value in pairs(dashboard_window_options) do
    vim.api.nvim_set_option_value(option, value, { scope = 'local', win = winid })
  end
end

local function reset_dashboard_window_options(winid)
  if not winid or winid == 0 or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  local saved_options = vim.w[winid].dashboard_saved_window_options
  if type(saved_options) ~= 'table' then
    return
  end

  for option, value in pairs(saved_options) do
    vim.api.nvim_set_option_value(option, value, { scope = 'local', win = winid })
  end

  vim.w[winid].dashboard_saved_window_options = nil
end

local function dashboard_menu_entries()
  local entries = {}
  local block_width = 0

  for _, shortcut in ipairs(dashboard_shortcuts) do
    local label = shortcut.icon .. ' ' .. shortcut.desc
    local label_width = vim.fn.strdisplaywidth(label)
    local key_width = vim.fn.strdisplaywidth(shortcut.key)
    block_width = math.max(block_width, label_width + 2 + key_width)
    entries[#entries + 1] = {
      label = label,
      label_width = label_width,
      key = shortcut.key,
      key_width = key_width,
    }
  end

  return entries, block_width
end

local function dashboard_content_height()
  return #dashboard_banner_lines() + 1 + #dashboard_shortcuts + 1 + 1
end

local function render_dashboard(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local winid = vim.fn.bufwinid(bufnr)
  if winid == -1 then
    return
  end

  local banner_lines = dashboard_banner_lines()
  local width = vim.api.nvim_win_get_width(winid)
  local height = vim.api.nvim_win_get_height(winid)
  local entries, block_width = dashboard_menu_entries()
  local menu_indent = math.max(0, math.floor((width - block_width) / 2))
  local top_padding = math.max(0, math.floor((height - dashboard_content_height()) / 2))
  local lines = {}
  local highlights = {}

  vim.b[bufnr].dashboard_winid = winid

  local function add_line(text, line_highlights)
    lines[#lines + 1] = text
    local row = #lines - 1
    for _, highlight in ipairs(line_highlights or {}) do
      highlights[#highlights + 1] = {
        group = highlight.group,
        line = row,
        start_col = highlight.start_col,
        end_col = highlight.end_col,
      }
    end
  end

  for _ = 1, top_padding do
    add_line ''
  end

  for _, banner_line in ipairs(banner_lines) do
    local line, indent = centered_line(banner_line, width)
    add_line(line, {
      {
        group = 'String',
        start_col = indent,
        end_col = indent + #banner_line,
      },
    })
  end

  add_line ''

  for _, entry in ipairs(entries) do
    local prefix = string.rep(' ', menu_indent)
    local gap = string.rep(' ', block_width - entry.label_width - entry.key_width)
    local line = prefix .. entry.label .. gap .. entry.key
    local key_start = #prefix + #entry.label + #gap
    add_line(line, {
      {
        group = 'Special',
        start_col = #prefix,
        end_col = #prefix + #entry.label,
      },
      {
        group = 'Number',
        start_col = key_start,
        end_col = key_start + #entry.key,
      },
    })
  end

  add_line ''

  local footer = vim.b[bufnr].dashboard_footer
  local footer_line, footer_indent = centered_line(footer, width)
  add_line(footer_line, {
    {
      group = 'Title',
      start_col = footer_indent,
      end_col = footer_indent + #footer,
    },
  })

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(bufnr, dashboard_ns, 0, -1)
  for _, highlight in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, dashboard_ns, highlight.group, highlight.line, highlight.start_col, highlight.end_col)
  end
  vim.bo[bufnr].modifiable = false
  set_dashboard_window_options(winid)
end

local function map_dashboard_shortcuts(bufnr)
  for _, shortcut in ipairs(dashboard_shortcuts) do
    vim.keymap.set('n', shortcut.key, function()
      vim.schedule(shortcut.action)
    end, {
      buffer = bufnr,
      desc = 'Dashboard ' .. shortcut.desc,
      nowait = true,
      silent = true,
    })
  end
end

local function open_dashboard(bufnr)
  vim.bo[bufnr].bufhidden = 'wipe'
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].filetype = 'native_dashboard'
  vim.bo[bufnr].modifiable = true
  vim.bo[bufnr].swapfile = false
  vim.b[bufnr].dashboard_footer = startup_stats_line()

  map_dashboard_shortcuts(bufnr)
  render_dashboard(bufnr)
end

vim.api.nvim_create_autocmd('VimEnter', {
  group = dashboard_group,
  once = true,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if is_startup_buffer(bufnr) then
      open_dashboard(bufnr)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'VimResized' }, {
  group = dashboard_group,
  callback = function(event)
    local bufnr = event.buf and event.buf ~= 0 and event.buf or vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype == 'native_dashboard' then
      render_dashboard(bufnr)
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = dashboard_group,
  callback = function(event)
    if vim.bo[event.buf].filetype == 'native_dashboard' then
      reset_dashboard_window_options(vim.b[event.buf].dashboard_winid)
    end
  end,
})

M.open = open_dashboard
M.render = render_dashboard

return M
