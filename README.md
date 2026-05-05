# Neovim Configuration

A minimal Neovim configuration built from scratch, migrated from lazy.nvim.
Prioritizes native Neovim features over plugins.

## Structure

```
init.lua
lua/
  config/
    init.lua         # Loads core config modules
    options.lua      # Editor options and settings
    keymaps.lua      # Key mappings
    diagnostics.lua  # Diagnostic display configuration
    autocmds.lua     # Auto commands
  plugins/
    init.lua         # Loads plugin modules
    colorscheme.lua  # TokyoNight color scheme (moon accent)
    completion.lua   # blink.cmp and snippet support
    formatting.lua   # conform.nvim formatter integration
    lsp.lua          # Mason and LSP tool installation
    syntax.lua       # Tree-sitter and autotag support
```

`init.lua` stays minimal and delegates to `lua/config/init.lua` and
`lua/plugins/init.lua`.

## Features

### Color Scheme

- **TokyoNight** (moon accent) — soft purple/blue tones on dark background
- Transparent background enabled

### Editor Settings

- Line numbers (absolute and relative)
- Tab/space handling (2 spaces, expandtab)
- Search settings (ignorecase, smartcase, live substitute preview)
- Terminal true colors with dark background
- Undo files enabled
- Mouse support enabled
- System clipboard integration (except in SSH sessions)

### Key Mappings

Leader key: `Space`

Mappings use `desc` metadata, so native `:map` output stays readable and
future key-hint plugins can reuse same descriptions.

#### Window Management

| Mapping      | Description               |
| ------------ | ------------------------- |
| `<leader>wv` | Split window vertically   |
| `<leader>wh` | Split window horizontally |
| `<leader>we` | Make splits equal size    |
| `<leader>wx` | Close current split       |

#### Tab Management

| Mapping              | Description      |
| -------------------- | ---------------- |
| `<leader><tab><tab>` | New tab          |
| `<leader><tab>d`     | Close tab        |
| `<leader><tab>f`     | First tab        |
| `<leader><tab>j`     | Next tab         |
| `<leader><tab>k`     | Previous tab     |
| `<leader><tab>l`     | Last tab         |
| `<leader><tab>o`     | Close other tabs |

#### Editing

| Mapping              | Description                        |
| -------------------- | ---------------------------------- |
| `<leader>+`          | Increment number                   |
| `<leader>-`          | Decrement number                   |
| `J` (visual)         | Move lines down                    |
| `K` (visual)         | Move lines up                      |
| `<leader>p` (visual) | Paste without overwriting register |
| `<leader>d`          | Delete without yanking             |
| `<leader>Y`          | Yank to system clipboard           |

#### Navigation

| Mapping   | Description                     |
| --------- | ------------------------------- |
| `<C-d>`   | Move down with cursor centered  |
| `<C-u>`   | Move up with cursor centered    |
| `n` / `N` | Search next/prev with centering |

#### Other

| Mapping      | Description            |
| ------------ | ---------------------- |
| `<ESC>`      | Clear search highlight |
| `<leader>cx` | Source current file    |
| `<leader>pu` | Update plugins         |
| `<leader>qq` | Quit all               |

### Diagnostics

- Virtual lines enabled for diagnostics
- Rounded borders on diagnostic floats
- Custom signs for each severity level
- Underline only for errors
- Virtual text shows source when multiple sources

### Auto Commands

- Highlight on yank
- Markdown files: textwidth=80, formatoptions set for prose

### Syntax and Completion

- **Tree-sitter** for syntax-aware parsing
- **nvim-ts-autotag** for paired tag editing in markup/component files
- **blink.cmp** with LuaSnip and friendly-snippets

## Formatting

- **conform.nvim** for format-on-save and manual formatting
- **StyLua** configured via `.stylua.toml`
- Additional formatters can be used when installed on the system

## Requirements

- Neovim 0.12+ (uses `vim.pack` for plugin management)
- Terminal with true color support
- Nerd Font recommended (for diagnostic signs)
- Rust toolchain (`cargo`) to build `blink.cmp`

## Installation

```bash
git clone <repo-url> ~/.config/nvim
```

## License

MIT
