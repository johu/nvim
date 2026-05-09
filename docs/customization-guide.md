# Customization Guide

This guide focuses on extension points that match the current repo style.

## Follow the repo rules first

Before changing behavior, keep these constraints in mind:

- prefer built-in Neovim APIs over new plugins
- keep modules explicit and small
- avoid new top-level directories
- use `vim.pack` for any plugin addition

## Common changes

### Change an option

- edit `lua/config/options.lua`
- keep related options grouped together

### Add a keymap

- general mappings belong in `lua/config/keymaps.lua`
- plugin-specific mappings usually belong in that plugin module
- use `desc` consistently

### Add a plugin

1. pick the narrowest existing plugin module that fits
2. add the plugin with `vim.pack.add`
3. configure it directly in that module
4. update `nvim-pack-lock.json`
5. update `README.md` and relevant docs when behavior changes

### Add an LSP server

1. register it in `lua/plugins/lsp.lua`
2. add its Mason package name
3. create `lsp/<server>.lua` only if extra config is needed

### Add a formatter

- extend `formatters_by_ft` in `lua/plugins/formatting.lua`
- if the formatter is required on new machines, also consider whether it
  belongs in the Mason ensure list

### Add snippets

- place runtime snippet files in the formats loaded by `mini.snippets`
- global snippets can use `all.*` or `global.*`
- language-specific snippets can use `<lang>/...` or `<lang>.*`

## Native UI customization

The native UI is split across:

- `lua/config/ui.lua`
- `lua/config/dashboard.lua`
- `lua/config/statusline.lua`

Reasonable edits there include:

- dashboard shortcut changes
- statusline section ordering
- palette or highlight tweaks
- git refresh cadence

Keep `ui.lua` as the small coordinator. Put dashboard changes in
`dashboard.lua` and statusline or git-cache changes in `statusline.lua` rather
than merging them back together.

## Avoid these mismatches

- do not document plugins that are not actually installed
- do not add `plenary.nvim` just to satisfy Harpoon; the repo already has a
  focused local shim
- do not reintroduce `lazy.nvim` or similar tooling
