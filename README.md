# Neovim Configuration

A minimal Neovim configuration built from scratch, migrated from lazy.nvim.
Prioritizes native Neovim features over plugins.

## Structure

```
init.lua
lua/
  config/
    options.lua      # Editor options and settings
    keymaps.lua      # Key mappings
    diagnostics.lua  # Diagnostic display configuration
    autocmds.lua     # Auto commands
  plugins/
    colorscheme.lua   # TokyoNight color scheme (moon accent)
```

`init.lua` requires all config files from `lua/config/`. No plugin manager configured yet.

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

## Formatting

- **StyLua** configured via `.stylua.toml`
- Standardized Lua code style

## Requirements

- Neovim 0.12+ (uses `vim.pack` for plugin management)
- Terminal with true color support
- Nerd Font recommended (for diagnostic signs)

## Installation

```bash
git clone <repo-url> ~/.config/nvim
```

## License

MIT
