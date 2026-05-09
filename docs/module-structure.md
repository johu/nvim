# Module Structure

This document describes the current layout and the role of each module.

## Entry points

```text
init.lua
lua/config/init.lua
lua/plugins/init.lua
```

- `init.lua` records startup time and loads `config` then `plugins`.
- `lua/config/init.lua` loads the core configuration modules.
- `lua/plugins/init.lua` loads each plugin module explicitly.

## Repo tree

```text
.
├── init.lua
├── lsp/
│   └── lua_ls.lua
├── lua/
│   ├── vim-pack.lua
│   ├── config/
│   │   ├── init.lua
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── diagnostics.lua
│   │   ├── autocmds.lua
│   │   ├── health.lua
│   │   ├── ui.lua
│   │   ├── dashboard.lua
│   │   └── statusline.lua
│   └── plugins/
│       ├── init.lua
│       ├── base.lua
│       ├── colorscheme.lua
│       ├── completion.lua
│       ├── editor.lua
│       ├── formatting.lua
│       ├── lsp.lua
│       ├── markdown.lua
│       ├── navigation.lua
│       ├── syntax.lua
│       ├── ui.lua
│       └── util.lua
└── nvim-pack-lock.json
```

## Core config modules

| File | Role |
| --- | --- |
| `lua/config/options.lua` | Sets `vim.opt`, filetypes, globals, and loads `nvim.undotree` |
| `lua/config/keymaps.lua` | Global non-plugin keymaps |
| `lua/config/diagnostics.lua` | Diagnostic styling and navigation keymaps |
| `lua/config/autocmds.lua` | Autocommands plus `PackUpdate` and `PackClean` |
| `lua/config/health.lua` | Custom health reporter |
| `lua/config/ui.lua` | Enables `ui2` and loads native UI modules |
| `lua/config/dashboard.lua` | Native startup dashboard |
| `lua/config/statusline.lua` | Native statusline, highlights, and git cache |

## Plugin modules

| File | Role |
| --- | --- |
| `lua/plugins/base.lua` | Loads `mini.nvim`, sets up icons |
| `lua/plugins/colorscheme.lua` | Installs and applies TokyoNight |
| `lua/plugins/completion.lua` | Blink completion plus snippet loaders |
| `lua/plugins/editor.lua` | `mini.surround`, `mini.jump2d`, `grug-far.nvim` |
| `lua/plugins/formatting.lua` | `conform.nvim` setup and format mapping |
| `lua/plugins/lsp.lua` | Mason, LSP server registration, `LspAttach` mappings |
| `lua/plugins/markdown.lua` | Markdown rendering and preview toggle |
| `lua/plugins/navigation.lua` | Harpoon, Oil, `fzf-lua`, local plenary shim |
| `lua/plugins/syntax.lua` | Tree-sitter, textobjects, autotag |
| `lua/plugins/ui.lua` | `tiny-cmdline`, `mini.notify`, `mini.clue`, `mini.tabline` |
| `lua/plugins/util.lua` | Session management with `mini.sessions` |

## LSP override modules

- `lsp/lua_ls.lua` contains the only repo-local server override today.
- `lua/plugins/lsp.lua` is already structured to load `lsp/<server>.lua` if a
  matching file exists.

## Structural observations

- The repo is explicit: there is no plugin abstraction layer beyond small
  helpers like `vim-pack.gh()`.
- The native UI is now split by concern: `ui.lua` is the loader,
  `dashboard.lua` owns startup UI, and `statusline.lua` owns statusline logic.
- Plugin modules stay focused on one concern each, which fits the project
  guidance in `AGENTS.md`.
