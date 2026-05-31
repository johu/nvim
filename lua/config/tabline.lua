local M = {}

local tabline_group = vim.api.nvim_create_augroup('config-native-tabline', { clear = true })

local default_palette = {
  bg            = '#222436',
  bg_statusline = '#1e2030',
  dark5         = '#737aa2',
  fg            = '#c8d3f5',
  fg_gutter     = '#3b4261',
}

local ICON_COLORS = { 'Azure', 'Blue', 'Cyan', 'Green', 'Grey', 'Orange', 'Purple', 'Red', 'Yellow' }
local TAB_STATES  = { 'Current', 'Visible', 'Hidden' }

local function tabline_palette()
  local ok, colors = pcall(function()
    return require('tokyonight.colors').setup()
  end)
  return ok and colors or default_palette
end

local function set_tabline_highlights()
  local colors      = tabline_palette()
  local bg          = colors.bg or default_palette.bg
  local bg_sl       = colors.bg_statusline or default_palette.bg_statusline
  local fg_gutter   = colors.fg_gutter or default_palette.fg_gutter

  local function set(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  set('NativeTablineCurrent', { fg = colors.fg,    bg = fg_gutter, bold = true })
  set('NativeTablineVisible', { fg = colors.fg,    bg = bg_sl })
  set('NativeTablineHidden',  { fg = colors.dark5, bg = bg_sl })
  set('NativeTablineFill',    { bg = bg })
  set('NativeTablineTabpage', { fg = colors.fg,    bg = fg_gutter })

  -- Composite icon groups: icon fg color on the correct tab-button background.
  -- NativeTablineIcon{State}{Color} = 3 states x 9 icon colors.
  local tab_bgs = { Current = fg_gutter, Visible = bg_sl, Hidden = bg_sl }
  local tab_fgs = { Current = colors.fg, Visible = colors.fg, Hidden = colors.dark5 }

  for _, state in ipairs(TAB_STATES) do
    for _, color in ipairs(ICON_COLORS) do
      local icon_hl = vim.api.nvim_get_hl(0, { name = 'MiniIcons' .. color, link = false })
      set('NativeTablineIcon' .. state .. color, {
        fg = icon_hl.fg or tab_fgs[state],
        bg = tab_bgs[state],
      })
    end
  end
end

vim.cmd([[
  function! NativeTablineSwitchBuffer(buf_id, clicks, button, mod)
    execute 'buffer' a:buf_id
  endfunction
]])

local function escape_tabline(text)
  return tostring(text):gsub('%%', '%%%%')
end

local function buf_display_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return '[No Name]'
  end
  local tail = vim.fn.fnamemodify(name, ':t')
  return tail ~= '' and tail or '[No Name]'
end

function M.tabline()
  local parts = {}

  -- Align tabs with the editor text area by prepending fill-colored padding
  -- equal to the current window's gutter width (line numbers + sign column, etc.)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  local textoff = (wininfo and wininfo[1] and wininfo[1].textoff) or 0
  local prefix  = textoff > 0 and ('%#NativeTablineFill#' .. (' '):rep(textoff)) or ''

  local bufs = vim.tbl_filter(
    function(b) return vim.bo[b].buflisted end,
    vim.api.nvim_list_bufs()
  )

  local current = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(bufs) do
    local state = bufnr == current and 'Current'
      or (vim.fn.bufwinnr(bufnr) > 0 and 'Visible' or 'Hidden')

    local name     = vim.api.nvim_buf_get_name(bufnr)
    local label    = escape_tabline(buf_display_name(bufnr))
    local modified = vim.bo[bufnr].modified and ' ●' or ''

    local icon_part = ''
    if _G.MiniIcons then
      local icon, icon_hl = MiniIcons.get('file', name)
      local color = icon_hl:match('^MiniIcons(.+)$') or 'Grey'
      icon_part = ('%%#NativeTablineIcon%s%s#%s'):format(state, color, icon)
    end

    local tab_hl = ('%%#NativeTabline%s#'):format(state)
    local click  = ('%%%d@NativeTablineSwitchBuffer@'):format(bufnr)

    parts[#parts + 1] = tab_hl .. click .. icon_part .. tab_hl .. ' ' .. label .. modified .. ' '
  end

  local fill = '%X%#NativeTablineFill#%='

  if vim.fn.tabpagenr('$') > 1 then
    local cur   = vim.fn.tabpagenr()
    local total = vim.fn.tabpagenr('$')
    fill = fill .. ('%%#NativeTablineTabpage# Tab %d/%d '):format(cur, total)
  end

  return prefix .. table.concat(parts, '') .. fill
end

set_tabline_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group    = tabline_group,
  callback = set_tabline_highlights,
})

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'config.tabline'.tabline()"

return M
