# UI Config

The UI stack is split between native config modules and `lua/plugins/ui.lua`.

## Native UI modules

`lua/config/ui.lua` is the loader for the native UI stack.

`lua/config/dashboard.lua` provides:

- a native startup dashboard

`lua/config/statusline.lua` provides:

- a native statusline
- cached git branch and diff state

`lua/config/ui.lua` itself enables:

- integration with `vim._core.ui2`

## Dashboard

The dashboard opens on `VimEnter` when Neovim starts with an empty unnamed
buffer and no file arguments.

### Dashboard shortcuts

| Key | Action |
| --- | --- |
| `f` | Find file |
| `n` | New file |
| `g` | Find text |
| `c` | Browse config |
| `s` | Restore session |
| `p` | Run `PackUpdate` |
| `N` | Open `:help news` in a float |
| `q` | Quit |

The footer shows startup time and plugin count derived from `vim.pack.get()`.

## Statusline

The statusline is fully custom and uses highlight groups built from the active
TokyoNight palette when available.

### Left side

- mode capsule
- current git branch
- git diff counts
- diagnostic counts
- filename and modified / readonly markers

### Right side

- active LSP client names
- active formatter names from Conform
- encoding
- filetype with icon from `mini.icons`
- progress
- cursor location

## Git caching

Git information is refreshed via `vim.system()` and cached per repo root.

- branch from `git branch --show-current`
- diff counts from `git status --porcelain --untracked-files=normal`
- cache window: 5 seconds unless forced refresh happens

Refresh events include:

- `BufEnter`
- `BufWritePost`
- `DirChanged`
- `FocusGained`

## Built-in command-line UI

`require('vim._core.ui2').enable {}` is called from `lua/config/ui.lua`.

## Plugin-backed helpers in `lua/plugins/ui.lua`

### `tiny-cmdline.nvim`

- keeps command-line entry usable with `cmdheight=0`
- configured to use Blink adapter repositioning

### `mini.notify`

- default setup

### `mini.clue`

- shows grouped hints for leader keys, brackets, `g`, marks, registers,
  windows, and `z`
- delay is `300ms`

### `mini.tabline`

- icons enabled
- tabpage section on the right

### `nvim-web-devicons` compatibility

The repo mocks `nvim-web-devicons` through `mini.icons` so plugins that expect
that API can still get icons without adding another dependency.
