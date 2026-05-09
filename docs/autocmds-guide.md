# Autocmds Guide

This document maps the behavior in `lua/config/autocmds.lua`.

## Utility helper

- `augroup(name)` creates groups prefixed with `user-`.

## Buffer and file lifecycle

| Event | Group | Behavior |
| --- | --- | --- |
| `FocusGained`, `TermClose`, `TermLeave` | `user-checktime` | Runs `:checktime` for normal buffers |
| `BufReadPost` | none | Restores last cursor position and recenters |
| `BufWritePre` | `user-auto-create-dir` | Creates parent directories before save |
| `WinEnter`, `BufEnter` | `cursorline` | Enables local cursorline |
| `WinLeave`, `BufLeave` | `user-cursorline` | Disables local cursorline |

## Editing behavior

| Event | Group | Behavior |
| --- | --- | --- |
| `TextYankPost` | `user-highlight-yank` | Calls `vim.hl.on_yank()` |
| `FileType` | `user-no-auto-comment` | Removes `c`, `r`, `o` from `formatoptions` |
| `VimResized` | `user-resize-splits` | Equalizes windows in every tab |

## Filetype-specific behavior

| Event | Pattern | Effect |
| --- | --- | --- |
| `FileType` | `help` | Moves help to a vertical split |
| `FileType` | `man` | Marks man buffers as unlisted |
| `FileType` | `text`, `plaintex`, `typst`, `gitcommit`, `markdown` | Enables local wrap and spell |
| `FileType` | `json`, `jsonc`, `json5` | Sets `conceallevel = 0` |
| `BufRead`, `BufNewFile` | `*.env`, `.env.*` | Sets filetype to `sh` |
| `BufRead`, `BufNewFile` | `*.tomg-config*` | Sets filetype to `toml` |
| `BufRead`, `BufNewFile` | `*.ejs`, `*.ejs.t` | Sets filetype to `embedded_template` |
| `BufRead`, `BufNewFile` | `*.code-snippets` | Sets filetype to `json` |
| `BufNewFile`, `BufRead` | `*.md` | Sets `textwidth = 80` and markdown `formatoptions` |

## Close-with-`q` buffers

For the following filetypes, the buffer is unlisted and gets a local `q`
mapping that closes the window and deletes the buffer:

- `checkhealth`
- `dbout`
- `gitsigns-blame`
- `grug-far`
- `help`
- `lspinfo`
- `neotest-output`
- `neotest-output-panel`
- `neotest-summary`
- `notify`
- `qf`
- `spectre_panel`
- `startuptime`
- `tsplayground`

Some entries are forward-compatible convenience patterns; they are not proof
that the related plugin is installed.

## Pack hooks

`PackChanged` reacts to install and update events:

- `nvim-treesitter` -> `packadd` if needed, then `:TSUpdate`
- `markdown-preview.nvim` -> `packadd` if needed, then
  `mkdp#util#install()`

## User commands

### `:PackUpdate`

Defined as:

- `:PackUpdate`
- `:PackUpdate!`
- `:PackUpdate name1 name2`
- `:PackUpdate! name1 name2`

Behavior:

- splits args by whitespace
- passes names or `nil` to `vim.pack.update()`
- forwards bang to `{ force = command.bang }`

### `:PackClean`

Behavior:

- inspects `vim.pack.get()`
- filters inactive specs
- removes them with `vim.pack.del()`
- notifies when nothing is removable or when cleanup succeeds
