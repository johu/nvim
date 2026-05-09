# Error Handling Patterns

The repo favors explicit failures and small guarded operations over broad
recovery logic.

## Common patterns in use

## Optional module loading

Used in `lua/plugins/lsp.lua`:

```lua
local ok, extra = pcall(require, 'lsp.' .. server_name)
if not ok then
  return server
end
```

This keeps per-server overrides optional without hiding configuration mistakes
elsewhere.

## Guarded editor actions

Used in `lua/config/keymaps.lua` for quickfix and location list toggles:

- wrap the open/close action in `pcall(...)`
- notify on failure with `vim.notify(..., vim.log.levels.ERROR)`

The code does not silently swallow the error.

## Guarded help opening

Used in `lua/config/dashboard.lua`:

- `pcall(vim.cmd.help, subject)`
- notify if the help topic cannot be opened

## External process checks

Used in:

- `lua/plugins/completion.lua`
- `lua/config/statusline.lua`

Patterns:

- inspect `obj.code`
- use explicit success or failure notifications
- avoid pretending a failed command succeeded

## Assertions for internal shims

Used in the Harpoon compatibility layer in `lua/plugins/navigation.lua`:

- `assert(uv.fs_open(...))`
- `assert(uv.fs_read(...))`
- `assert(uv.fs_write(...))`

This is appropriate because the shim is an internal implementation detail, not
user-facing input parsing.

## Early returns for invalid state

Frequent in `lua/config/dashboard.lua`, `lua/config/statusline.lua`, and
`lua/config/autocmds.lua`:

- invalid buffer/window -> return
- wrong event kind -> return
- no git root -> return
- no inactive plugins -> notify and return

These are narrow state guards, not silent error suppression.

## Practical takeaway

The repo generally prefers:

- explicit notifications
- small guarded calls
- precise early exits for non-applicable states
- optional extension points through `pcall(require, ...)`

It avoids broad `xpcall` wrappers and catch-all retry logic.
