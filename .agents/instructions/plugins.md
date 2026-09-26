# Plugin Management

- All plugins must be added via `vim.pack`.
- Do not reintroduce `lazy.vim` or similar tools.
- Avoid excessive lazy-loading unless it provides measurable benefit.

## Rules

- Each plugin must:
  - Solve a real problem
  - Be actively maintained (or stable enough to trust)
  - Be documented with a short comment explaining _why it exists_

Example:

```lua
-- Better syntax parsing than regex highlighting
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})
```

- Prefer:
  - Fewer plugins
  - Clear responsibilities per plugin
  - Direct configuration over wrapper abstractions

## Testing

- Run `mise run plugins` after changes to plugin setup, package
  declarations, or LSP configuration.
