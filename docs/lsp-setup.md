# LSP Setup

This file reflects the actual LSP stack in `lua/plugins/lsp.lua`.

## Installed plugins

- `neovim/nvim-lspconfig`
- `mason-org/mason.nvim`
- `mason-org/mason-lspconfig.nvim`
- `WhoIsSethDaniel/mason-tool-installer.nvim`

## Configured servers

Only these servers are enabled today:

| Server | Mason package | Notes |
| --- | --- | --- |
| `lua_ls` | `lua-language-server` | Has repo-local override in `lsp/lua_ls.lua` |
| `marksman` | `marksman` | Markdown LSP |

## Server override loading

`extend_server_config(server_name, server)` tries to load:

```lua
require('lsp.' .. server_name)
```

If the module exists, it is merged with the base server spec via
`vim.tbl_deep_extend('force', ...)`.

Current override files:

- `lsp/lua_ls.lua`

## Global LSP defaults

Applied through:

```lua
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  root_markers = { '.git' },
})
```

## Tool installation

`mason-tool-installer.nvim` ensures these items are present:

- `lua-language-server`
- `marksman`
- `shellcheck`
- `shfmt`
- `stylua`
- `markdownlint-cli2`
- `markdown-toc`
- `prettier`

## Buffer-local mappings on `LspAttach`

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
| `<leader>th` | Toggle inlay hints if supported |

## Extra attach behavior

- document highlights on `CursorHold` / `CursorHoldI`
- clearing references on movement
- cleanup on `LspDetach`

## `lua_ls` override

`lsp/lua_ls.lua` currently adds:

- `runtime.version = 'LuaJIT'`
- `workspace.library = vim.api.nvim_get_runtime_file('', true)`

## Extending this setup

To add another server in the current style:

1. add it to the `servers` table in `lua/plugins/lsp.lua`
2. map its Mason package name in `mason`
3. optionally create `lsp/<server>.lua`
4. keep the override file small and server-specific
