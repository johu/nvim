# Keymaps Reference

This file tracks the keymaps defined in the current repo.

Leader: `<Space>`

## Core mappings

| Mapping | Mode | Action |
| --- | --- | --- |
| `<ESC>` | n | Clear search highlight |
| `x` | n | Delete char without yanking |
| `<leader>cx` | n | Source current file |
| `<leader>qq` | n | Quit all |
| `<Tab>` / `<S-Tab>` | n | Next / previous buffer |
| `<C-h/j/k/l>` | n | Move between windows |
| `<C-d>` / `<C-u>` | n | Half-page move with centering |
| `n` / `N` | n | Next / previous match with centering |
| `gh` / `gl` | n | Start / end of line |
| `<A-h>` / `<A-l>` | n | Start / end of line |
| `==` | n | Select whole buffer |
| `<A-a>` | n | Select whole buffer |
| `J` | n | Join line and keep cursor context |
| `J` / `K` | v | Move selected lines down / up |
| `<A-j>` / `<A-k>` | n/i/v | Move lines down / up |
| `j` / `k` | n/x | Visual-line motion without count |
| `<` / `>` | v | Reindent and keep selection |
| `<leader>p` | x | Paste without overwriting register |
| `p` | v | Paste without keeping replaced text |
| `<leader>d` | n/v | Delete without yanking |
| `<C-c>` | n | Copy whole file to clipboard |
| `<leader>Y` | n | Yank line to clipboard |
| `` ` " ( [ { < `` | i | Insert auto-closing pair |
| `gco` / `gcO` | n | Add comment below / above |
| `z0` | n | Accept first spelling suggestion |
| `<leader>tw` | n | Toggle wrap |
| `<leader>K` | n | Run `K` via `keywordprg` |

## Window and tab management

| Mapping | Action |
| --- | --- |
| `<leader>wv` | Split vertically |
| `<leader>wh` | Split horizontally |
| `<leader>we` | Equalize splits |
| `<leader>wx` | Close split |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>f` | First tab |
| `<leader><tab>j` | Next tab |
| `<leader><tab>k` | Previous tab |
| `<leader><tab>l` | Last tab |
| `<leader><tab>o` | Close other tabs |

## Quickfix, diagnostics, and inspection

| Mapping | Action |
| --- | --- |
| `<leader>xq` | Toggle quickfix list |
| `<leader>xl` | Toggle location list |
| `[q` / `]q` | Previous / next quickfix item |
| `<leader>cd` | Line diagnostics float |
| `[d` / `]d` | Previous / next diagnostic |
| `[e` / `]e` | Previous / next error |
| `[w` / `]w` | Previous / next warning |
| `<leader>ui` | `vim.show_pos()` |
| `<leader>uI` | `:InspectTree` |
| `[u` / `]u` | Older / newer text state |
| `<leader>ut` | Open undotree |

## Navigation and search

| Mapping | Action |
| --- | --- |
| `-` | Open Oil |
| `<leader>H` | Add file to Harpoon |
| `<leader>h` | Toggle Harpoon menu |
| `<A-h/j/k/l>` | Harpoon file 1/2/3/4 |
| `<leader>ff` | Files |
| `<leader>fg` | Git files |
| `<leader>fb` | Buffers |
| `<leader>fk` | Keymaps |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fu` | Builtin `fzf-lua` pickers |
| `<leader>sb` | Current buffer grep |
| `<leader>sg` | Live grep |
| `<leader>sw` / `<leader>sW` | Grep current word / WORD |
| `<leader>sd` / `<leader>sD` | Document / workspace diagnostics |
| `<leader>sR` | Resume last picker |
| `<leader>st` | Search TODO, FIX, FIXME |
| `<leader>gc` / `<leader>gs` | Git commits / status |
| `<leader>ec` / `<leader>ep` | Config files / installed packages |
| `<leader>/` | Live grep |
| `<leader>,` | MRU buffers |
| `<leader>:` | Command history |
| `<leader><leader>` | Files |

## Editing plugins

| Mapping | Action |
| --- | --- |
| `<leader>j` | `mini.jump2d` single-character jump |
| `<leader>sr` | `grug-far` search and replace |
| `af` / `if` | Tree-sitter function textobjects |
| `ac` / `ic` | Tree-sitter class textobjects |
| `ao` | Tree-sitter comment textobject |
| `as` | Tree-sitter local scope textobject |
| `<leader>a` / `<leader>A` | Swap next / previous parameter |

## LSP mappings

These are buffer-local and appear on `LspAttach`.

| Mapping | Action |
| --- | --- |
| `grn` | Rename |
| `gra` | Code action |
| `grr` | References via `fzf-lua` |
| `gri` | Implementations via `fzf-lua` |
| `grd` | Definitions via `fzf-lua` |
| `grD` | Declaration |
| `grt` | Type definitions via `fzf-lua` |
| `gO` | Document symbols via `fzf-lua` |
| `gW` | Workspace symbols via `fzf-lua` |
| `<leader>th` | Toggle inlay hints when supported |

## Formatting and sessions

| Mapping | Action |
| --- | --- |
| `<leader>mp` | Format file or visual selection |
| `<leader>qs` | Restore session |
| `<leader>qS` | Select session |
| `<leader>ql` | Restore latest session |
| `<leader>qd` | Detach current session |

## Markdown

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>cp` | n (markdown buffer) | Toggle browser preview |

## Plugin maintenance

| Mapping | Action |
| --- | --- |
| `<leader>pu` | `:PackUpdate` |
| `<leader>pc` | `:PackClean` |
