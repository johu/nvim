# Formatting Setup

Formatting is configured in `lua/plugins/formatting.lua`.

## Plugin

- `stevearc/conform.nvim`

## Format on save

```lua
format_on_save = {
  lsp_fallback = true,
  async = false,
  timeout_ms = 1000,
}
```

## Manual formatting

`<leader>mp` formats the current buffer, or the current selection in visual
mode, with the same fallback and timeout behavior.

## Formatter map

| Filetype | Formatter(s) |
| --- | --- |
| `css` | `prettier` |
| `graphql` | `prettier` |
| `html` | `prettier` |
| `javascript` | `prettier` |
| `javascriptreact` | `prettier` |
| `json` | `prettier` |
| `liquid` | `prettier` |
| `lua` | `stylua` |
| `markdown` | `prettier`, `markdownlint-cli2`, `markdown-toc` |
| `python` | `isort`, `black` |
| `typescript` | `prettier` |
| `typescriptreact` | `prettier` |
| `svelte` | `prettier` |
| `yaml` | `prettier` |
| `xml` | `xmllint` |

## Conditional markdown helpers

Two formatters are guarded:

### `markdown-toc`

Runs only when the buffer contains:

```text
<!-- toc -->
```

### `markdownlint-cli2`

Runs only when current diagnostics include an entry whose source is
`markdownlint`.

## Notes

- `vim.g.autoformat = true` exists in `options.lua`, but Conform behavior is
  driven directly by its own setup in this repo.
- `isort` and `black` are configured here but not included in the Mason ensure
  list, so Python formatting assumes system-level installation.
