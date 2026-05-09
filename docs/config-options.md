# Config Options

This is a focused inventory of the current settings in
`lua/config/options.lua`.

## General editing

- `number = true`
- `relativenumber = true`
- `signcolumn = 'yes'`
- `cursorline = true`
- `wrap = false`
- `scrolloff = 10`
- `sidescrolloff = 8`

## Indentation

- `tabstop = 2`
- `shiftwidth = 2`
- `softtabstop = 2`
- `expandtab = true`
- `smarttab = true`
- `autoindent = true`
- `smartindent = true`
- `breakindent = true`
- `shiftround = true`

## Search and replace

- `ignorecase = true`
- `smartcase = true`
- `incsearch = true`
- `inccommand = 'split'`
- `grepprg = 'rg --vimgrep'`
- `grepformat = '%f:%l:%c:%m'`
- `iskeyword` appends `-`

## UI and command line

- `termguicolors = true`
- `background = 'dark'`
- `cmdheight = 0`
- `showmode = false`
- `pumheight = 10`
- `pumblend = 10`
- `completeopt = 'menu,menuone,noselect,popup'`
- `ruler = false`
- `laststatus = 3`
- `showcmdloc = 'statusline'`
- `wildmenu = true`
- `wildmode = 'longest:full,full'`
- `winborder = 'rounded'`

## Files and persistence

- `backup = false`
- `writebackup = false`
- `swapfile = false`
- `undofile = true`
- `undolevels = 10000`
- `autoread = true`
- `hidden = true`
- `path` appends `**`

## Behavior

- `mouse = 'a'`
- `selection = 'exclusive'`
- `virtualedit = 'block'`
- `splitright = true`
- `splitbelow = true`
- `splitkeep = 'screen'`
- `jumpoptions = 'view'`
- `linebreak = true`
- `smoothscroll = true`
- `timeoutlen = 300`
- `ttimeoutlen = 0`

## Whitespace and display

- `list = true`
- `listchars = { tab = '» ', trail = '·', nbsp = '␣' }`
- custom `fillchars` for folds, diff, and end-of-buffer
- `conceallevel = 2` globally, with JSON filetypes forced back to `0`

## Spell and prose defaults

- `spell = true`
- `spelllang = { 'en_us' }`
- prose filetypes also get local `wrap = true` in `autocmds.lua`

## Performance-related values

- `synmaxcol = 300`
- `updatetime = 300`
- `redrawtime = 10000`
- `maxmempattern = 20000`

## Globals and runtime setup

- `vim.g.mapleader = ' '`
- `vim.g.maplocalleader = ' '`
- `vim.g.autoformat = true`
- `vim.g.markdown_recommended_style = 0`
- `vim.cmd('let g:netrw_liststyle = 3')`
- `vim.cmd('packadd nvim.undotree')`

## Filetype additions

- Hyprland config pattern -> `hyprlang`
- `.env`, `env`, and `.env.*` patterns -> `dotenv`
- `jsconfig*.json` and `tsconfig*.json` patterns -> `jsonc`

## Notes

- Some filetype detection also exists in `lua/config/autocmds.lua`; the repo
  currently uses both `vim.filetype.add()` and explicit autocommands.
