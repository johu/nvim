# Syntax Setup

Syntax support lives in `lua/plugins/syntax.lua`.

## Installed plugins

- `nvim-treesitter/nvim-treesitter`
- `nvim-treesitter/nvim-treesitter-textobjects`
- `windwp/nvim-ts-autotag`

## Tree-sitter setup

Current setup enables:

- autotag integration
- incremental selection

Incremental selection mappings:

| Mapping | Action |
| --- | --- |
| `<Enter>` | Init or expand selection |
| `<BS>` | Shrink selection |

## Auto-start behavior

A `FileType` autocmd tries to start Tree-sitter for every buffer:

- `pcall(vim.treesitter.start)`
- sets `vim.bo.indentexpr` to Tree-sitter indentation

## Parser bootstrap list

The repo asks Tree-sitter to install a wide default set, including:

- shell and config: `bash`, `dockerfile`, `tmux`, `toml`, `yaml`, `ini`
- web: `html`, `css`, `javascript`, `typescript`, `tsx`, `xml`
- systems: `c`, `cpp`, `zig`, `cmake`, `ninja`
- scripting: `lua`, `python`
- docs and text: `markdown`, `markdown_inline`, `vimdoc`
- git and repo files: `diff`, `git_config`, `gitcommit`, `gitignore`
- extra environment-specific grammars such as `hyprlang`

The exact list is defined in `ensure_installed` inside the module.

## Textobjects

Configured selections:

| Mapping | Query |
| --- | --- |
| `af` / `if` | function outer / inner |
| `ac` / `ic` | class outer / inner |
| `ao` | comment outer |
| `as` | local scope |

Selection settings:

- `lookahead = true`
- parameter outer uses visual mode
- function outer uses linewise visual mode
- class outer uses blockwise visual mode
- surrounding whitespace is included

## Swapping

| Mapping | Action |
| --- | --- |
| `<leader>a` | Swap with next parameter |
| `<leader>A` | Swap with previous parameter |
