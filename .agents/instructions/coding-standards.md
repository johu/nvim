# Coding Standards

## Lua

- Use idiomatic Lua
- Prefer `local` over globals
- Avoid unnecessary abstraction layers
- Keep functions small and composable

## Testing

- Run `mise run smoke` after changes to core configuration, filetype
  detection, or autocmd behavior.
- Keep smoke tests independent of user-installed plugins.
