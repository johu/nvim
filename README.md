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
    ui.lua           # Built-in history and command-line helpers
    diagnostics.lua  # Diagnostic display configuration
    autocmds.lua     # Auto commands
  plugins/
    init.lua         # Loads plugin modules
    base.lua         # Base utilities (plenary, mini.nvim)
    colorscheme.lua  # TokyoNight color scheme (moon accent)
    completion.lua   # blink.cmp and snippet support
    editor.lua       # mini.nvim editing helpers
    formatting.lua   # conform.nvim formatter integration
    lsp.lua          # Mason and LSP tool installation
    navigation.lua   # Harpoon, Oil, fzf-lua
    syntax.lua       # Tree-sitter and autotag support
    ui.lua           # mini.clue, statusline, and tabline
    util.lua         # session workflow helpers
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
- Compact built-in command-line UI with message history

### Editing

- **mini.pairs** inserts matching delimiters while typing
- **mini.surround** adds, changes, and deletes surroundings
- **mini.jump2d** provides single-character jump labels on `<leader>j` in
  normal, visual, and operator-pending modes

### Key Mappings

Leader key: `Space`

Mappings use `desc` metadata, so native `:map` output stays readable and
`mini.clue` can surface grouped hints from same descriptions.

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
| `<leader>j`          | Jump with `mini.jump2d` (n/x/o)    |
| `<leader>Y`          | Yank to system clipboard           |
| `[u` / `]u`          | Older/newer undo state             |
| `<leader>uh`         | Undo history                       |
| `<leader>um`         | Message history                    |
| `<leader>uc`         | Command-line window                |

#### Navigation

| Mapping   | Description                     |
| --------- | ------------------------------- |
| `<C-d>`   | Move down with cursor centered  |
| `<C-u>`   | Move up with cursor centered    |
| `n` / `N` | Search next/prev with centering |

#### File Navigation

| Mapping      | Description              |
| ------------ | ------------------------ |
| `-`          | Open file explorer       |
| `<leader>ff` | Find files               |
| `<leader>fg` | Git files                |
| `<leader>fb` | Buffers                  |
| `<leader><leader>` | Find files (alt)     |
| `<leader>,` | Switch buffer (MRU)      |

#### Harpoon (Fast Navigation)

| Mapping       | Description             |
| ------------- | ----------------------- |
| `<leader>H`   | Add file to harpoon     |
| `<leader>h`   | Toggle harpoon menu     |
| `<A-h>`       | Go to harpoon file 1    |
| `<A-j>`       | Go to harpoon file 2    |
| `<A-k>`       | Go to harpoon file 3    |
| `<A-l>`       | Go to harpoon file 4    |

#### Search and Diagnostics

| Mapping      | Description                      |
| ------------ | -------------------------------- |
| `<leader>sg` | Grep (live)                      |
| `<leader>sw` | Grep current word                |
| `<leader>sW` | Grep current WORD                |
| `<leader>st` | Search todos/fixes               |
| `<leader>sb` | Search buffer                    |
| `<leader>sd` | Diagnostics (document)           |
| `<leader>sD` | Diagnostics (workspace)          |
| `<leader>/` | Grep (alt)                       |
| `<leader>:` | Command history                  |
| `<leader>fk` | Keymaps                          |
| `<leader>fh` | Help tags                        |
| `<leader>fr` | Recent files                     |
| `<leader>ec` | Neovim config files              |
| `<leader>ep` | Plugin packages                  |

#### Git

| Mapping      | Description          |
| ------------ | -------------------- |
| `<leader>gc` | Git commits          |
| `<leader>gs` | Git status           |

#### Sessions

| Mapping      | Description             |
| ------------ | ----------------------- |
| `<leader>qs` | Restore current session |
| `<leader>qS` | Select session          |
| `<leader>ql` | Restore last session    |
| `<leader>qd` | Detach current session  |

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

### UI

- **mini.clue** shows grouped key hints for leader keys, windows, registers,
  marks, and built-in motions
- **mini.statusline** handles mode/status display in a compact statusline
- **mini.tabline** adds icon-aware buffer tabs across top
- Native Neovim UI keeps the command line compact and exposes message history
  without `noice.nvim`

### Sessions

- **mini.sessions** replaces persistence.nvim for save, restore, and session
  selection flows
- Sessions autowrite by default, and `<leader>qd` detaches current session
  before write

### Auto Commands

- Highlight on yank
- Markdown files: textwidth=80, formatoptions set for prose

### Navigation

- **Harpoon 2** for fast file jumping with Alt+hjkl shortcuts
- **Oil.nvim** for file explorer with `-` keymap
- **fzf-lua** for fuzzy find across files, buffers, git, diagnostics, and more

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
