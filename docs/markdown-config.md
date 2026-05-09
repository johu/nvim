# Markdown Config

Markdown behavior is split across `lua/plugins/markdown.lua`,
`lua/plugins/formatting.lua`, and `lua/config/autocmds.lua`.

## Plugins

- `MeanderingProgrammer/render-markdown.nvim`
- `iamcco/markdown-preview.nvim`

## In-editor rendering

`render-markdown.nvim` is set up with its default configuration:

```lua
require('render-markdown').setup {}
```

The module then runs `do FileType` so markdown-specific filetype behavior is
applied immediately.

## Browser preview

`toggle_markdown_preview()` does two things:

1. calls `mkdp#util#install_sync(1)`
2. calls `mkdp#util#toggle_preview()`

The preview keymap is buffer-local and only created for `markdown` filetypes:

| Mapping | Action |
| --- | --- |
| `<leader>cp` | Toggle markdown preview |

## Markdown prose defaults

From `lua/config/autocmds.lua`:

- markdown buffers get `wrap = true`
- markdown buffers get `spell = true`
- `*.md` buffers get `textwidth = 80`
- markdown `formatoptions` become `tcqawjp]`

From `lua/config/options.lua`:

- `vim.g.markdown_recommended_style = 0`

## Markdown formatting

From Conform:

- `prettier`
- `markdownlint-cli2`
- `markdown-toc`

`markdown-toc` only runs when the buffer contains `<!-- toc -->`.

## Pack hooks

On plugin install or update, `PackChanged` ensures
`markdown-preview.nvim` gets its install step.
