local M = {}

local git_cache = {}
local dashboard_group = vim.api.nvim_create_augroup('config-native-dashboard', { clear = true })
local dashboard_ns = vim.api.nvim_create_namespace 'config-native-dashboard'
local git_refresh_group = vim.api.nvim_create_augroup('config-native-statusline-git', { clear = true })
local statusline_group = vim.api.nvim_create_augroup('config-native-statusline', { clear = true })
local open_help_float

local default_palette = {
  bg_dark = '#1e2030',
  bg_highlight = '#2f334d',
  bg_statusline = '#1e2030',
  blue = '#82aaff',
  blue0 = '#3e68d7',
  comment = '#636da6',
  dark3 = '#545c7e',
  dark5 = '#737aa2',
  fg = '#c8d3f5',
  fg_dark = '#828bb8',
  git = {
    add = '#b8db87',
    change = '#7ca1f2',
    delete = '#e26a75',
  },
  green = '#c3e88d',
  orange = '#ff966c',
  purple = '#fca7ea',
  red = '#ff757f',
  teal = '#4fd6be',
  yellow = '#ffc777',
}

local icons = {
  branch = '',
  column = '',
  error = '',
  hint = '󰌵',
  info = '',
  lsp = '',
  modified = '●',
  readonly = '',
  warn = '',
  diff = {
    added = '+',
    modified = '~',
    removed = '-',
  },
}

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

local function escape_statusline(text)
  return tostring(text):gsub('%%', '%%%%')
end

local function join_nonempty(parts, sep)
  return table.concat(vim.tbl_filter(function(part)
    return part and part ~= ''
  end, parts), sep or '')
end

local function hl(group, text)
  return ('%%#%s#%s'):format(group, text)
end

local function default_git_diff()
  return { added = 0, modified = 0, removed = 0 }
end

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
  local win = vim.wo[winid]
  win.colorcolumn = ''
  win.cursorcolumn = false
  win.cursorline = false
  win.foldcolumn = '0'
  win.foldmethod = 'manual'
  win.list = false
  win.number = false
  win.relativenumber = false
  win.signcolumn = 'no'
  win.sidescrolloff = 0
  win.spell = false
  win.statuscolumn = ''
  win.wrap = false
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

local function statusline_palette()
  local ok, colors = pcall(function()
    return require('tokyonight.colors').setup()
  end)

  return ok and colors or default_palette
end

local function segment(group, text)
  return hl(group, ' ' .. text .. ' ')
end

local function set_statusline_highlights()
  local colors = statusline_palette()
  local base_bg = colors.bg_statusline or colors.bg_dark
  local function set(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  set('StatusLine', { bg = base_bg, fg = colors.fg })
  set('StatusLineNC', { bg = base_bg, fg = colors.comment })

  for group, color in pairs {
    NativeStatusModeNormal = colors.blue,
    NativeStatusModeInsert = colors.green,
    NativeStatusModeVisual = colors.purple,
    NativeStatusModeReplace = colors.red,
    NativeStatusModeCommand = colors.yellow,
    NativeStatusModeTerminal = colors.orange,
  } do
    set(group, { bg = color, fg = base_bg, bold = true })
    set(group .. 'ToBranch', { bg = colors.dark3, fg = color })
    set(group .. 'ToBase', { bg = base_bg, fg = color })
  end

  set('NativeStatusBranch', { bg = colors.dark3, fg = colors.fg, bold = true })
  set('NativeStatusBranchToBase', { bg = base_bg, fg = colors.dark3 })

  set('NativeStatusFilename', { bg = base_bg, fg = colors.fg_dark })
  set('NativeStatusMeta', { bg = base_bg, fg = colors.comment })
  set('NativeStatusDivider', { bg = base_bg, fg = colors.dark5 })

  set('NativeStatusFiletype', { bg = colors.dark3, fg = colors.fg, bold = true })
  set('NativeStatusBaseToFiletype', { bg = base_bg, fg = colors.dark3 })
  set('NativeStatusProgress', { bg = colors.blue0, fg = base_bg, bold = true })
  set('NativeStatusFiletypeToProgress', { bg = colors.dark3, fg = colors.blue0 })
  set('NativeStatusLocation', { bg = colors.blue, fg = base_bg, bold = true })
  set('NativeStatusProgressToLocation', { bg = colors.blue0, fg = colors.blue })

  set('NativeStatusDiffAdd', { bg = base_bg, fg = colors.git.add, bold = true })
  set('NativeStatusDiffChange', { bg = base_bg, fg = colors.git.change, bold = true })
  set('NativeStatusDiffDelete', { bg = base_bg, fg = colors.git.delete, bold = true })

  set('NativeStatusDiagError', { bg = base_bg, fg = colors.red, bold = true })
  set('NativeStatusDiagWarn', { bg = base_bg, fg = colors.yellow, bold = true })
  set('NativeStatusDiagInfo', { bg = base_bg, fg = colors.teal, bold = true })
  set('NativeStatusDiagHint', { bg = base_bg, fg = colors.green, bold = true })

  set('NativeStatusInactive', { bg = base_bg, fg = colors.comment })
end

local function git_root(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    path = vim.uv.cwd()
  end

  return vim.fs.root(path, '.git')
end

local function parse_git_status(output)
  local diff = default_git_diff()

  for line in output:gmatch '[^\r\n]+' do
    local index = line:sub(1, 1)
    local worktree = line:sub(2, 2)

    if index == '?' and worktree == '?' then
      diff.added = diff.added + 1
    elseif index ~= '!' and worktree ~= '!' then
      if index == 'A' or worktree == 'A' then
        diff.added = diff.added + 1
      end

      if index == 'D' or worktree == 'D' then
        diff.removed = diff.removed + 1
      end

      if vim.list_contains({ 'M', 'R', 'C', 'U' }, index) or vim.list_contains({ 'M', 'R', 'C', 'U' }, worktree) then
        diff.modified = diff.modified + 1
      end
    end
  end

  return diff
end

local function redraw_statusline()
  vim.schedule(function()
    pcall(vim.cmd, 'redrawstatus')
  end)
end

local function refresh_git_status(root, force)
  if not root then
    return
  end

  local now = vim.uv.hrtime()
  local cache = git_cache[root]

  if cache and cache.pending then
    return
  end

  if not force and cache and cache.updated_at and now - cache.updated_at < 5 * 1e9 then
    return
  end

  git_cache[root] = vim.tbl_extend('force', cache or {}, { pending = true })

  local result = {
    branch = cache and cache.branch or '',
    diff = cache and cache.diff or default_git_diff(),
  }
  local pending = 2

  local function done()
    pending = pending - 1
    if pending > 0 then
      return
    end

    git_cache[root] = {
      branch = result.branch,
      diff = result.diff,
      updated_at = vim.uv.hrtime(),
      pending = false,
    }

    redraw_statusline()
  end

  vim.system({ 'git', '-C', root, 'branch', '--show-current' }, { text = true }, function(obj)
    result.branch = obj.code == 0 and vim.trim(obj.stdout or '') or ''
    vim.schedule(done)
  end)

  vim.system({ 'git', '-C', root, 'status', '--porcelain', '--untracked-files=normal' }, { text = true }, function(obj)
    result.diff = obj.code == 0 and parse_git_status(obj.stdout or '') or default_git_diff()
    vim.schedule(done)
  end)
end

local function current_statusline_win()
  local winid = tonumber(vim.g.statusline_winid)
  if winid and vim.api.nvim_win_is_valid(winid) then
    return winid
  end

  return vim.api.nvim_get_current_win()
end

local function mode_definition()
  local mode = vim.api.nvim_get_mode().mode

  return ({
    n = { label = 'NORMAL', group = 'NativeStatusModeNormal' },
    no = { label = 'O-PENDING', group = 'NativeStatusModeNormal' },
    nov = { label = 'O-PENDING', group = 'NativeStatusModeNormal' },
    noV = { label = 'O-PENDING', group = 'NativeStatusModeNormal' },
    ['no\22'] = { label = 'O-PENDING', group = 'NativeStatusModeNormal' },
    niI = { label = 'NORMAL', group = 'NativeStatusModeNormal' },
    niR = { label = 'NORMAL', group = 'NativeStatusModeNormal' },
    niV = { label = 'NORMAL', group = 'NativeStatusModeNormal' },
    nt = { label = 'NORMAL', group = 'NativeStatusModeNormal' },
    v = { label = 'VISUAL', group = 'NativeStatusModeVisual' },
    vs = { label = 'VISUAL', group = 'NativeStatusModeVisual' },
    V = { label = 'V-LINE', group = 'NativeStatusModeVisual' },
    Vs = { label = 'V-LINE', group = 'NativeStatusModeVisual' },
    ['\22'] = { label = 'V-BLOCK', group = 'NativeStatusModeVisual' },
    ['\22s'] = { label = 'V-BLOCK', group = 'NativeStatusModeVisual' },
    s = { label = 'SELECT', group = 'NativeStatusModeVisual' },
    S = { label = 'S-LINE', group = 'NativeStatusModeVisual' },
    ['\19'] = { label = 'S-BLOCK', group = 'NativeStatusModeVisual' },
    i = { label = 'INSERT', group = 'NativeStatusModeInsert' },
    ic = { label = 'INSERT', group = 'NativeStatusModeInsert' },
    ix = { label = 'INSERT', group = 'NativeStatusModeInsert' },
    R = { label = 'REPLACE', group = 'NativeStatusModeReplace' },
    Rc = { label = 'REPLACE', group = 'NativeStatusModeReplace' },
    Rx = { label = 'REPLACE', group = 'NativeStatusModeReplace' },
    Rv = { label = 'V-REPLACE', group = 'NativeStatusModeReplace' },
    c = { label = 'COMMAND', group = 'NativeStatusModeCommand' },
    cv = { label = 'EX', group = 'NativeStatusModeCommand' },
    ce = { label = 'EX', group = 'NativeStatusModeCommand' },
    r = { label = 'PROMPT', group = 'NativeStatusModeCommand' },
    rm = { label = 'MORE', group = 'NativeStatusModeCommand' },
    ['r?'] = { label = 'CONFIRM', group = 'NativeStatusModeCommand' },
    ['!'] = { label = 'SHELL', group = 'NativeStatusModeTerminal' },
    t = { label = 'TERMINAL', group = 'NativeStatusModeTerminal' },
  })[mode] or { label = mode, group = 'NativeStatusModeNormal' }
end

local function pretty_label(name)
  return escape_statusline((name or ''):gsub('[_%-]', ' '))
end

local function formatter_names(bufnr)
  local ok, conform = pcall(require, 'conform')
  if not ok or type(conform.list_formatters_to_run) ~= 'function' then
    return {}
  end

  local ok_formatters, formatters = pcall(conform.list_formatters_to_run, bufnr)
  if not ok_formatters or vim.tbl_isempty(formatters) then
    return {}
  end

  return vim.tbl_map(function(formatter)
    return pretty_label(formatter.name)
  end, formatters)
end

local function filetype_icon(filetype)
  local ok, mini_icons = pcall(require, 'mini.icons')
  if not ok then
    return ''
  end

  local icon = select(1, mini_icons.get('filetype', filetype))
  return icon and (icon .. ' ') or ''
end

local function mode_section(has_branch)
  local mode = mode_definition()
  local sep = mode.group .. (has_branch and 'ToBranch' or 'ToBase')
  return segment(mode.group, mode.label) .. hl(sep, '') .. '%*'
end

local function branch_section(bufnr)
  local root = git_root(bufnr)
  if not root then
    return ''
  end

  refresh_git_status(root, false)

  local branch = (git_cache[root] or {}).branch or ''
  if branch == '' then
    return ''
  end

  return segment('NativeStatusBranch', icons.branch .. ' ' .. escape_statusline(branch)) .. hl('NativeStatusBranchToBase', '') .. '%*'
end

local function diff_section(bufnr)
  local root = git_root(bufnr)
  if not root then
    return ''
  end

  refresh_git_status(root, false)

  local diff = (git_cache[root] or {}).diff or default_git_diff()
  local parts = {}

  if diff.added > 0 then
    parts[#parts + 1] = hl('NativeStatusDiffAdd', (' %s%d '):format(icons.diff.added, diff.added))
  end

  if diff.modified > 0 then
    parts[#parts + 1] = hl('NativeStatusDiffChange', (' %s%d '):format(icons.diff.modified, diff.modified))
  end

  if diff.removed > 0 then
    parts[#parts + 1] = hl('NativeStatusDiffDelete', (' %s%d '):format(icons.diff.removed, diff.removed))
  end

  return join_nonempty(parts, '') .. (#parts > 0 and '%*' or '')
end

local function diagnostics_section(bufnr)
  local parts = {}

  for _, item in ipairs {
    { severity = vim.diagnostic.severity.ERROR, group = 'NativeStatusDiagError', icon = icons.error },
    { severity = vim.diagnostic.severity.WARN, group = 'NativeStatusDiagWarn', icon = icons.warn },
    { severity = vim.diagnostic.severity.INFO, group = 'NativeStatusDiagInfo', icon = icons.info },
    { severity = vim.diagnostic.severity.HINT, group = 'NativeStatusDiagHint', icon = icons.hint },
  } do
    local count = #vim.diagnostic.get(bufnr, { severity = item.severity })
    if count > 0 then
      parts[#parts + 1] = hl(item.group, (' %s%d '):format(item.icon, count))
    end
  end

  return join_nonempty(parts, '') .. (#parts > 0 and '%*' or '')
end

local function filename_section(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local display_name = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  local flags = {}

  if vim.bo[bufnr].modified then
    flags[#flags + 1] = icons.modified
  end

  if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
    flags[#flags + 1] = icons.readonly
  end

  return hl(
    'NativeStatusFilename',
    ' ' .. escape_statusline(display_name) .. (#flags > 0 and (' ' .. table.concat(flags, ' ')) or '') .. ' '
  ) .. '%*'
end

local function lsp_section(bufnr)
  local names = {}
  local seen = {}
  local formatter_lookup = {}

  for _, name in ipairs(formatter_names(bufnr)) do
    formatter_lookup[name] = true
  end

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    local name = pretty_label(client.name)
    if not seen[name] and not formatter_lookup[name] then
      seen[name] = true
      names[#names + 1] = name
    end
  end

  if vim.tbl_isempty(names) then
    return ''
  end

  table.sort(names)
  return hl('NativeStatusMeta', ' ' .. icons.lsp .. ' ' .. table.concat(names, ', ') .. ' ') .. '%*'
end

local function formatter_section(bufnr)
  local names = formatter_names(bufnr)
  if vim.tbl_isempty(names) then
    return ''
  end

  return hl('NativeStatusMeta', ' ' .. table.concat(names, ', ') .. ' ') .. '%*'
end

local function encoding_section(bufnr)
  local encoding = vim.bo[bufnr].fileencoding ~= '' and vim.bo[bufnr].fileencoding or vim.o.encoding
  return hl('NativeStatusMeta', ' ' .. escape_statusline(encoding:lower()) .. ' ') .. '%*'
end

local function meta_separator()
  return hl('NativeStatusDivider', '') .. '%*'
end

local function filetype_section(bufnr)
  local filetype = vim.bo[bufnr].filetype ~= '' and vim.bo[bufnr].filetype or 'text'
  return hl('NativeStatusBaseToFiletype', '') .. segment('NativeStatusFiletype', filetype_icon(filetype) .. pretty_label(filetype)) .. '%*'
end

local function progress_section()
  return hl('NativeStatusFiletypeToProgress', '') .. segment('NativeStatusProgress', '%P') .. '%*'
end

local function location_section()
  return hl('NativeStatusProgressToLocation', '') .. segment('NativeStatusLocation', '%l:%c') .. '%*'
end

local function inactive_statusline(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local display_name = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  return hl('NativeStatusInactive', ' ' .. escape_statusline(display_name) .. ' ') .. '%*'
end

function M.statusline()
  local winid = current_statusline_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)

  if vim.bo[bufnr].filetype == 'native_dashboard' then
    return ''
  end

  if winid ~= vim.api.nvim_get_current_win() and vim.o.laststatus ~= 3 then
    return inactive_statusline(bufnr)
  end

  local branch = branch_section(bufnr)
  local left = join_nonempty({
    mode_section(branch ~= ''),
    branch,
    diff_section(bufnr),
    diagnostics_section(bufnr),
    filename_section(bufnr),
  }, '')

  local meta = join_nonempty({
    lsp_section(bufnr),
    formatter_section(bufnr),
    encoding_section(bufnr),
  }, meta_separator())

  local right = join_nonempty({
    meta,
    filetype_section(bufnr),
    progress_section(),
    location_section(),
  }, '')

  return left .. '%=' .. right
end

set_statusline_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = statusline_group,
  callback = set_statusline_highlights,
})

require('vim._core.ui2').enable {}

vim.o.statusline = "%!v:lua.require'config.ui'.statusline()"

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

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'DirChanged', 'FocusGained' }, {
  group = git_refresh_group,
  callback = function(event)
    local root = git_root(event.buf)
    if root then
      refresh_git_status(root, true)
    end
  end,
})

return M
