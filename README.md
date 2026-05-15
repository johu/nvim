# Neovim Configuration

A minimal Neovim configuration built from scratch. Prioritizes native
Neovim features over plugins.

## Requirements

- Neovim 0.12+ (uses `vim.pack` for plugin management)
- Terminal with true color support
- Nerd Font recommended (for diagnostic signs)
- `curl` required for the first `markdown-preview.nvim` launch
- Rust toolchain (`cargo`) to build `blink.cmp`

## Installation

- Backup your old config before

```bash
mv ~/.config/nvim ~/.config/nvim-backup
```

- Remove state & cache files (or backup at your choice)

```bash
rm -rf ~/.local/share/nvim \
       ~/.cache/nvim \
       ~/.local/state/nvim
```

- Clone the repository

```bash
git clone https://github.com/johu/nvim.git ~/.config/nvim
```

## Structure

```
init.lua
lua/
  vim-pack.lua       # vim.pack plugin manager setup
  config/
    init.lua         # Loads core config modules
    options.lua      # Editor options and settings
    keymaps.lua      # Key mappings
    ui.lua           # Enables Neovim's builtin ui2 features
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
    markdown.lua     # Markdown rendering and browser preview
    navigation.lua   # Harpoon, Oil, fzf-lua
    syntax.lua       # Tree-sitter and autotag support
    ui.lua           # mini.clue, statusline, and tabline
    util.lua         # session workflow helpers
nvim-pack-lock.json  # Plugin lock file (commit required)
```

`init.lua` stays minimal and delegates to `lua/config/init.lua` and
`lua/plugins/init.lua`. Plugin setup via `vim-pack.lua` using native `vim.pack`.

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

- Native keymaps auto-close pairs while typing
- **mini.surround** adds, changes, and deletes surroundings
- **mini.jump2d** provides single-character jump labels on `<leader>j` in
  normal, visual, and operator-pending modes
- **grug-far** provides a focused search-and-replace UI on `<leader>sr`

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
| `<leader>ut`         | Open undo tree                     |

#### Navigation

| Mapping   | Description                     |
| --------- | ------------------------------- |
| `<C-d>`   | Move down with cursor centered  |
| `<C-u>`   | Move up with cursor centered    |
| `n` / `N` | Search next/prev with centering |

#### File Navigation

| Mapping            | Description         |
| ------------------ | ------------------- |
| `-`                | Open file explorer  |
| `<leader>ff`       | Find files          |
| `<leader>fg`       | Git files           |
| `<leader>fb`       | Buffers             |
| `<leader>fu`       | Builtin pickers     |
| `<leader><leader>` | Find files (alt)    |
| `<leader>,`        | Switch buffer (MRU) |

#### Harpoon (Fast Navigation)

| Mapping     | Description          |
| ----------- | -------------------- |
| `<leader>H` | Add file to harpoon  |
| `<leader>h` | Toggle harpoon menu  |
| `<A-h>`     | Go to harpoon file 1 |
| `<A-j>`     | Go to harpoon file 2 |
| `<A-k>`     | Go to harpoon file 3 |
| `<A-l>`     | Go to harpoon file 4 |

#### Search and Diagnostics

| Mapping       | Description             |
| ------------- | ----------------------- |
| `<leader>sg`  | Grep (live)             |
| `<leader>sw`  | Grep current word       |
| `<leader>sW`  | Grep current WORD       |
| `<leader>sR`  | Resume last picker      |
| `<leader>st`  | Search todos/fixes      |
| `<leader>sb`  | Search buffer           |
| `<leader>cd`  | Diagnostic float        |
| `]d` / `[d`   | Next/prev diagnostic    |
| `]e` / `[e`   | Next/prev error         |
| `]w` / `[w`   | Next/prev warning       |
| `<leader>sd`  | Diagnostics (document)  |
| `<leader>sD`  | Diagnostics (workspace) |
| `<leader>/`   | Grep (alt)              |
| `<leader>:`   | Command history         |
| `<leader>fk`  | Keymaps                 |
| `<leader>fh`  | Help tags               |
| `<leader>fr`  | Recent files            |
| `<leader>ec`  | Neovim config files     |
| `<leader>ep`  | Plugin packages         |

#### LSP

| Mapping       | Description                  |
| ------------- | ---------------------------- |
| `grn`         | Rename symbol                |
| `gra`         | Code actions                 |
| `grr`         | References (fzf)             |
| `gri`         | Implementation (fzf)         |
| `grd`         | Definition (fzf)             |
| `grD`         | Declaration                  |
| `grt`         | Type definition (fzf)        |
| `gO`          | Document symbols (fzf)       |
| `gW`          | Workspace symbols (fzf)      |

#### Git

| Mapping      | Description |
| ------------ | ----------- |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status  |

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
| `<leader>cp` | Markdown preview       |
| `<leader>pc` | Cleanup plugins        |
| `<leader>pu` | Update plugins         |
| `<leader>qq` | Quit all               |

### Diagnostics

- Virtual lines enabled for diagnostics
- Rounded borders on diagnostic floats
- Custom signs for each severity level
- Underline only for errors
- Virtual text shows source when multiple sources
- Line highlighting for each severity (ERROR, WARN, INFO, HINT)
- DAP breakpoint sign definition for debugger support
- Navigation keymaps: `]d`/`[d` (all), `]e`/`[e` (errors), `]w`/`[w` (warnings), `<leader>cd` (float)

### UI

- **snacks.nvim** restores a startup dashboard when Neovim opens without files
- **mini.clue** shows grouped key hints for leader keys, windows, registers,
  marks, and built-in motions
- **lualine.nvim** restores the richer branch/diff/diagnostics/LSP statusline
- **mini.tabline** adds icon-aware buffer tabs across top
- Built-in `ui2` provides the compact command-line and message UI
- `q:` opens command-line history, `:messages`/`g<` open message history, and
  `:undolist` shows undo history
- **tiny-cmdline.nvim** keeps the command line usable with `cmdheight=0`

### Sessions

- **mini.sessions** replaces persistence.nvim for save, restore, and session
  selection flows
- Sessions autowrite by default, and `<leader>qd` detaches current session
  before write

### Auto Commands & User Commands

**Auto Commands:**
- **Highlight on yank** — visual feedback when copying
- **Checktime** — reload file if changed externally (FocusGained, TermClose, TermLeave)
- **Restore cursor position** — resume at last edit location on BufReadPost
- **Resize splits** — auto-equalize on VimResized
- **Help vertical split** — open help pages in vertical split
- **Man unlisted** — mark man pages as unlisted
- **Close with `q`** — quick exit for 40+ filetypes (help, qf, lspinfo, checkhealth, gitsigns-blame, etc.)
- **Wrap and spell** — enabled for text/markdown/plaintex/typst/gitcommit
- **JSON conceal** — conceallevel=0 to prevent quote hiding
- **Auto-create dirs** — mkdir -p parent on buffer write
- **Filetype detection** — .env/.env.* (sh), .toml (toml), .ejs/.ejs.t (embedded_template), .code-snippets (json)
- **Markdown** — textwidth=80, formatoptions for prose
- **PackChanged hooks** — auto-run TSUpdate on treesitter install/update, build markdown-preview.nvim

**User Commands:**
- **PackUpdate** — `PackUpdate` or `PackUpdate! pkg1 pkg2` for update with force
- **PackClean** — remove inactive plugins from disk

### Navigation

- **Harpoon 2** for fast file jumping with Alt+hjkl shortcuts
- **Oil.nvim** for file explorer with `-` keymap
- **fzf-lua** for fuzzy find across files, buffers, git, diagnostics, and more

### Search and Replace

- **grug-far** adds scoped search-and-replace with a transient UI that defaults
  to the current file extension on `<leader>sr`

### Markdown

- **render-markdown.nvim** improves in-editor Markdown rendering
- **markdown-preview.nvim** toggles a browser preview with `<leader>cp`

### Syntax and Completion

- **Tree-sitter** for syntax-aware parsing
- **nvim-treesitter-textobjects** restores textobjects and parameter swapping
- Tree-sitter incremental selection uses `<Enter>` to expand and `<BS>` to
  shrink
- **nvim-ts-autotag** for paired tag editing in markup/component files
- **blink.cmp** with LuaSnip and friendly-snippets

### LSP

- Built-in `vim.lsp` config with Mason-managed installs for `lua_ls`, `gopls`,
  and `marksman`
- `gr*` mappings restore fzf-backed references, definitions, implementations,
  type definitions, rename, and code actions on attach
- LSP document highlights and inlay hint toggling are restored

## Formatting

- **conform.nvim** for format-on-save and manual formatting
- **StyLua** configured via `.stylua.toml`
- Additional formatters can be used when installed on the system
