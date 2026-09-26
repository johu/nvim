local map = vim.keymap.set
local sev = vim.diagnostic.severity

local palette = {
  err = '#51202A',
  warn = '#3B3B1B',
  info = '#1F3342',
  hint = '#1E2E1E',
}

vim.api.nvim_set_hl(0, 'DiagnosticErrorLine', { bg = palette.err, blend = 20 })
vim.api.nvim_set_hl(0, 'DiagnosticWarnLine', { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, 'DiagnosticInfoLine', { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, 'DiagnosticHintLine', { bg = palette.hint, blend = 10 })

vim.api.nvim_set_hl(0, 'DapBreakpointSign', { fg = '#FF0000', bg = nil, bold = true })
vim.fn.sign_define('DapBreakpoint', {
  text = '●',
  texthl = 'DapBreakpointSign', -- the highlight group you just defined
  linehl = '', -- no full-line highlight
  numhl = '', -- no number-column highlight
})

vim.diagnostic.config {
  -- Wrap virtual lines wider than the window onto extra rows instead of
  -- horizontally scrolling them (the 'auto' default scrolls when 'wrap' is off,
  -- which it is globally). current_line defaults to false, so all lines show.
  virtual_lines = { overflow = 'wrap' },

  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [sev.ERROR] = '󰅚 ',
      [sev.WARN] = '󰀪 ',
      [sev.INFO] = '󰋽 ',
      [sev.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  linehl = {
    [sev.ERROR] = 'DiagnosticErrorLine',
    [sev.WARN] = 'DiagnosticWarnLine',
    [sev.INFO] = 'DiagnosticInfoLine',
    [sev.HINT] = 'DiagnosticHintLine',
  },
}

-- open a float for the diagnostic we land on (replaces the deprecated
-- `float = true` option of vim.diagnostic.jump)
local function show_jumped_float(diagnostic, bufnr)
  if not diagnostic then
    return
  end
  vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor' }
end

local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { count = next and 1 or -1, on_jump = show_jumped_float, severity = severity }
  end
end

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })
