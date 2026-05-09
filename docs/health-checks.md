# Health Checks

The repo defines a custom health checker in `lua/config/health.lua`.

## How to run it

```vim
:checkhealth config
```

## What it checks

### Neovim version

- Minimum required version: `0.12.0`
- Uses `vim.version.ge()`
- Reports `ok()` when the running version is new enough
- Reports `error()` otherwise

### External executables

The checker looks for:

- `git`
- `make`
- `unzip`
- `curl`
- `rg`
- `fzf`
- `fd` or `fdfind`

Each dependency produces:

- `ok()` when found
- `warn()` when missing

## Extra output

- Emits system information from `vim.uv.os_uname()`

## What it does not check

The current health checker does **not** verify:

- Mason-installed tools individually
- Blink's Rust toolchain
- Tree-sitter parser installation state
- markdown-preview browser dependencies

Those issues are instead surfaced by runtime failures, Mason status, or plugin
messages.
