# Feature Index

This is the current feature map for the repo as implemented today.

## Native foundation

- Native plugin management through `vim.pack`
- Native dashboard in `lua/config/dashboard.lua`
- Native statusline in `lua/config/statusline.lua`
- Native UI loader in `lua/config/ui.lua`
- Built-in `vim._core.ui2` enabled for compact command-line UI
- Built-in diagnostics, autocommands, user commands, and health checks

## Core editor behavior

- Relative and absolute line numbers
- Two-space indentation with `expandtab`
- Smart-case search and split preview for substitutions
- Undo files enabled
- Clipboard integration outside SSH sessions
- Global spell checking with prose-focused local overrides
- Rounded floating window borders
- Cursorline only in the active window

## UI helpers

- `tokyonight.nvim` for colors
- `tiny-cmdline.nvim` for `cmdheight=0`
- `mini.notify` for notifications
- `mini.clue` for grouped key hints
- `mini.tabline` for buffer tabs
- `mini.icons` as the icon layer, including a mocked `nvim-web-devicons`

## Editing and search

- Native insert-pair mappings in `lua/config/keymaps.lua`
- `mini.surround`
- `mini.jump2d` on `<leader>j`
- `grug-far.nvim` on `<leader>sr`
- Quickfix and location list toggles
- `fzf-lua` for files, grep, buffers, help, diagnostics, git, and history

## Navigation

- Harpoon 2 with a local compatibility shim instead of `plenary.nvim`
- `oil.nvim` on `-`
- Buffer cycling with `<Tab>` and `<S-Tab>`
- Tab management under `<leader><tab>`

## Completion and snippets

- `blink.cmp`
- `blink.lib`
- `mini.snippets`
- `friendly-snippets`
- Rust-backed fuzzy matching when available
- Cmdline ghost text enabled through Blink

## Language support

- LSP stack: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`,
  `mason-tool-installer.nvim`
- Configured servers: `lua_ls`, `marksman`
- LSP-specific override file: `lsp/lua_ls.lua`
- Tree-sitter parsers for a broad default language set
- `nvim-treesitter-textobjects`
- `nvim-ts-autotag`

## Formatting and markdown

- `conform.nvim` for format-on-save and manual formatting
- Markdown formatters: `prettier`, `markdownlint-cli2`, `markdown-toc`
- `render-markdown.nvim`
- `markdown-preview.nvim` with buffer-local `<leader>cp`

## Sessions and maintenance

- `mini.sessions` with autowrite
- `PackUpdate[!] [names...]`
- `PackClean`
- `PackChanged` hooks for Tree-sitter updates and markdown preview install
- Custom health checks for Neovim version and external executables

## Not in this repo

The current config does **not** set up:

- DAP
- neotest
- `noice.nvim`
- `lualine.nvim`
- `snacks.nvim`
- extra LSP servers beyond `lua_ls` and `marksman`
