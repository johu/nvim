# Plugin Management

The repo uses only native `vim.pack`.

## Helper

`lua/vim-pack.lua` exposes:

```lua
require('vim-pack').gh('owner/repo')
```

which expands to the full GitHub URL.

## Loading model

- each plugin area has its own Lua module under `lua/plugins/`
- each module calls `vim.pack.add { ... }`
- `lua/plugins/init.lua` requires every module explicitly

There is no second plugin manager and no wrapper DSL beyond the small GitHub
URL helper.

## Installed plugin set

| Module | Plugins |
| --- | --- |
| `base.lua` | `mini.nvim` |
| `colorscheme.lua` | `tokyonight.nvim` |
| `completion.lua` | `friendly-snippets`, `blink.lib`, `blink.cmp` |
| `editor.lua` | `grug-far.nvim` plus `mini.surround` / `mini.jump2d` from `mini.nvim` |
| `formatting.lua` | `conform.nvim` |
| `lsp.lua` | `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim` |
| `markdown.lua` | `render-markdown.nvim`, `markdown-preview.nvim` |
| `navigation.lua` | `harpoon`, `oil.nvim`, `fzf-lua` |
| `syntax.lua` | `nvim-treesitter`, `nvim-treesitter-textobjects`, `nvim-ts-autotag` |
| `ui.lua` | `tiny-cmdline.nvim` plus `mini.notify`, `mini.clue`, `mini.tabline` from `mini.nvim` |
| `util.lua` | `mini.sessions` from `mini.nvim` |

## Commands

### `:PackUpdate`

- updates all plugins when called without args
- updates named plugins when args are given
- `!` passes `force = true`

### `:PackClean`

- removes inactive plugin directories from disk

## PackChanged hooks

Defined in `lua/config/autocmds.lua`:

- install/update `nvim-treesitter` -> run `:TSUpdate`
- install/update `markdown-preview.nvim` -> run its install helper

Defined in `lua/plugins/completion.lua`:

- install/update `blink.cmp` -> run `cargo build --release`

## Lock file

- `nvim-pack-lock.json` is committed and should stay in sync with the installed
  plugin set

## Repo fit

This matches the project constraints in `AGENTS.md`:

- native first
- minimalism
- explicit loading
- no extra abstraction layer
