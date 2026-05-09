# Defaults Audit

This file highlights where the repo intentionally differs from stock Neovim.

## Editor defaults changed

| Area | Current choice | Why it matters |
| --- | --- | --- |
| Numbers | `number` + `relativenumber` | Motion-oriented editing |
| Indent | 2 spaces, `expandtab` | Consistent repo-wide default |
| Search | `ignorecase` + `smartcase` | Fast default, precise override |
| Replace preview | `inccommand = 'split'` | Native preview during substitution |
| Undo | `undofile = true`, `undolevels = 10000` | Strong recovery history |
| Mouse | `mouse = 'a'` | Full mouse support |
| Clipboard | `unnamedplus` outside SSH | Better local clipboard UX |
| Splits | right + below | Predictable layout |

## UI defaults changed

| Area | Current choice | Notes |
| --- | --- | --- |
| Command line | `cmdheight = 0` | Paired with `tiny-cmdline.nvim` |
| Statusline | `laststatus = 3` | Single global statusline |
| Borders | `winborder = 'rounded'` | Shared float style |
| Cursorline | enabled only in active window | Managed by autocommands |
| Listchars | visible tabs / trails / nbsp | Whitespace stays explicit |
| Fillchars | custom fold and EOB styling | Cleaner visual layout |
| Conceal | `conceallevel = 2` globally | JSON buffers opt out locally |

## Behavior defaults changed

| Area | Current choice | Notes |
| --- | --- | --- |
| Comment continuation | disabled on new lines | Managed with `formatoptions` removal |
| Jump behavior | `jumpoptions = 'view'` | Preserves view state |
| Visual movement | `j` / `k` become screen-line aware | Count still forces real-line motion |
| Wrap | off globally, on for prose filetypes | Better coding default |
| Spell | on globally | Local prose autocmd reinforces it |

## Runtime defaults changed

- `vim._core.ui2` is explicitly enabled
- `nvim.undotree` is loaded with `packadd`
- custom filetype detection is added for Hyprland and dotenv patterns

## Notable trade-offs

- global `spell = true` is unusual for a coding config, but filetype-local
  behavior and UI choices suggest prose support is intentional
- the native UI is split into focused modules instead of one large
  catch-all file
