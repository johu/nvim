# Troubleshooting

This guide only covers issues grounded in the current repo.

## First checks

1. Run `:checkhealth config`
2. Run `:messages`
3. Run `:PackUpdate`

## Neovim version problems

Symptom:

- config fails on startup
- `vim.pack` or `vim.lsp.config()` is missing

Fix:

- use Neovim `0.12+`

## Missing external tools

Symptom:

- health warnings for required executables
- grep, picker, or install flows fail

Fix:

- install missing tools reported by `:checkhealth config`
- especially `git`, `curl`, `rg`, `fzf`, and `fd` or `fdfind`

## Blink build issues

Symptom:

- completion setup errors after plugin update
- Blink build notifications report failure

Fix:

- install a Rust toolchain with `cargo`
- rerun `:PackUpdate blink.cmp`

## Mason or LSP issues

Symptom:

- `lua_ls` or `marksman` does not attach
- LSP keymaps are unavailable in a buffer

Fix:

- confirm Mason installed the required packages
- check filetype detection
- inspect `:messages`
- verify that only `lua_ls` and `marksman` are configured by default

## Markdown preview issues

Symptom:

- `<leader>cp` does nothing
- preview install errors appear

Fix:

- open an actual markdown buffer first
- ensure `curl` is installed
- rerun `:PackUpdate markdown-preview.nvim`

## Tree-sitter issues

Symptom:

- parser-based highlighting or textobjects are missing

Fix:

- update parsers with `:TSUpdate`
- confirm the filetype is part of the parser list in `lua/plugins/syntax.lua`

## UI confusion

Symptom:

- docs or expectations mention `lualine`, `noice`, or `snacks`

Fix:

- ignore those older references
- the current repo uses a native dashboard and native statusline in
  `lua/config/dashboard.lua` and `lua/config/statusline.lua`

## Session issues

Symptom:

- `MiniSessions.read()` restores nothing

Fix:

- confirm a session was previously written
- use `<leader>qS` to inspect available sessions
- use `<leader>qd` before closing when you do not want the current session
  reused
