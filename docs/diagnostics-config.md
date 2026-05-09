# Diagnostics Config

This summarizes `lua/config/diagnostics.lua`.

## Highlight groups

Custom line highlights are defined for each severity:

- `DiagnosticErrorLine`
- `DiagnosticWarnLine`
- `DiagnosticInfoLine`
- `DiagnosticHintLine`

There is also a custom `DapBreakpoint` sign definition, even though DAP itself
is not configured in this repo.

## `vim.diagnostic.config()`

Current settings:

- `virtual_lines = true`
- `severity_sort = true`
- `float = { border = 'rounded', source = 'if_many' }`
- `underline = { severity = vim.diagnostic.severity.ERROR }`
- custom sign text for error, warn, info, hint
- `virtual_text = { spacing = 4, source = 'if_many', prefix = '●' }`
- `linehl` maps each severity to the custom line highlight group

## Navigation helper

`diagnostic_goto(next, severity)` returns a function that calls
`vim.diagnostic.jump()` with:

- `count = 1` or `-1`
- `float = true`
- optional severity filter

## Keymaps

| Mapping | Action |
| --- | --- |
| `<leader>cd` | Open float for current line |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `]w` / `[w` | Next / previous warning |

## Interaction with the rest of the repo

- `fzf-lua` exposes document and workspace diagnostic pickers through
  `<leader>sd` and `<leader>sD`.
- The native statusline in `lua/config/statusline.lua` shows per-severity
  counts.
