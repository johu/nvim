# Navigation Guide

Navigation features live mostly in `lua/plugins/navigation.lua`.

## Installed plugins

- `ThePrimeagen/harpoon` (`harpoon2` branch)
- `stevearc/oil.nvim`
- `ibhagwan/fzf-lua`

## Harpoon without plenary

This repo intentionally avoids `plenary.nvim`.

To keep Harpoon working, `lua/plugins/navigation.lua` provides small local
compatibility modules for:

- `plenary.path`
- `plenary.reload`

The shim only implements the surface Harpoon needs for path persistence and
reload behavior.

## Harpoon keymaps

| Mapping | Action |
| --- | --- |
| `<leader>H` | Add current file |
| `<leader>h` | Toggle quick menu |
| `<A-h>` | Jump to file 1 |
| `<A-j>` | Jump to file 2 |
| `<A-k>` | Jump to file 3 |
| `<A-l>` | Jump to file 4 |

## Oil

| Mapping | Action |
| --- | --- |
| `-` | Open Oil |

Oil is configured with:

- `view_options.show_hidden = true`

## `fzf-lua`

`fzf-lua` is initialized with an empty setup table, then wired through keymaps.

### File and help pickers

- `<leader>ff` -> files
- `<leader>fg` -> git files
- `<leader>fb` -> buffers
- `<leader>fk` -> keymaps
- `<leader>fh` -> help tags
- `<leader>fr` -> recent files
- `<leader>fu` -> builtins
- `<leader><leader>` -> files
- `<leader>,` -> MRU buffers

### Search pickers

- `<leader>sg` -> live grep
- `<leader>sw` -> grep current word
- `<leader>sW` -> grep current WORD
- `<leader>sb` -> grep current buffer
- `<leader>sR` -> resume
- `<leader>st` -> grep `TODO|FIX|FIXME`
- `<leader>/` -> live grep
- `<leader>:` -> command history

### Diagnostics and git

- `<leader>sd` -> document diagnostics
- `<leader>sD` -> workspace diagnostics
- `<leader>gc` -> git commits
- `<leader>gs` -> git status

### Repo-local convenience pickers

- `<leader>ec` -> files under `stdpath('config')`
- `<leader>ep` -> files under the local package install directory

## Terminal behavior inside FZF

A `FileType=fzf` autocmd sets terminal-mode bindings for:

- `<C-j>`
- `<C-k>`
