# Documentation Index

This directory is a repo-state analysis of the current configuration.

## Current doc set

### Core config

- `config-options.md` - editor options and globals from `lua/config/options.lua`
- `keymaps-reference.md` - active keymaps from `lua/config/keymaps.lua` and
  plugin modules
- `autocmds-guide.md` - autocommands and user commands from
  `lua/config/autocmds.lua`
- `diagnostics-config.md` - `vim.diagnostic` setup and navigation
- `health-checks.md` - custom `:checkhealth config` checks
- `module-structure.md` - current file layout and module responsibilities

### Plugin modules

- `plugin-management.md` - `vim.pack` layout, hooks, and installed plugins
- `completion-config.md` - `blink.cmp`, `mini.snippets`, friendly snippets
- `formatting-setup.md` - `conform.nvim` formatters and `<leader>mp`
- `lsp-setup.md` - Mason, LSP servers, overrides in `lsp/`
- `markdown-config.md` - markdown rendering, preview, prose defaults
- `navigation-guide.md` - Harpoon, Oil, and `fzf-lua`
- `syntax-setup.md` - Tree-sitter, autotag, textobjects
- `ui-config.md` - native dashboard/statusline plus `mini.*` UI helpers

### Analysis and maintenance

- `customization-guide.md` - safe extension points that fit the repo style
- `defaults-audit.md` - notable deviations from stock Neovim defaults
- `error-handling-patterns.md` - recurring defensive patterns in the Lua code
- `feature-index.md` - high-level feature map
- `performance-tuning.md` - current performance choices and profiling tips
- `troubleshooting.md` - common failure modes grounded in this repo

## Source of truth

These docs should match:

- `README.md` for user-facing overview
- `AGENTS.md` for project principles
- `init.lua`, `lua/config/`, `lua/plugins/`, and `lsp/` for implementation

## Repo snapshot

```text
init.lua
lsp/
  lua_ls.lua
lua/
  vim-pack.lua
  config/
    init.lua
    options.lua
    keymaps.lua
    diagnostics.lua
    autocmds.lua
    health.lua
    ui.lua
    dashboard.lua
    statusline.lua
  plugins/
    init.lua
    base.lua
    colorscheme.lua
    completion.lua
    editor.lua
    formatting.lua
    lsp.lua
    markdown.lua
    navigation.lua
    syntax.lua
    ui.lua
    util.lua
nvim-pack-lock.json
```

## Notes

- The UI is now primarily native. `lua/config/ui.lua` is a small loader for
  `dashboard.lua` and `statusline.lua`.
- Only `lua_ls` and `marksman` are configured as LSP servers.
- The docs no longer reference non-existent analysis files or removed plugin
  stacks.
