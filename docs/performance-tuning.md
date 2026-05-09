# Performance Tuning

This document covers performance choices already present in the repo and how to
measure them.

## Current performance-oriented choices

- `vim.pack` instead of an external plugin manager
- relatively small plugin set
- native dashboard and statusline instead of extra UI plugins
- cached git status in the statusline
- `synmaxcol = 300`
- `updatetime = 300`
- `redrawtime = 10000`
- `timeoutlen = 300`
- broad Tree-sitter parser bootstrap so syntax support is ready without manual
  churn later

## Git statusline cache

`lua/config/statusline.lua` avoids running git commands on every redraw:

- cache key: repo root
- cache TTL: 5 seconds
- async refresh via `vim.system()`

If the statusline feels noisy or heavy, this cache is the first place to tune.

## Profiling startup

Use Neovim's built-in startup profiling instead of a startup plugin:

```bash
nvim --startuptime /tmp/nvim-startup.log +qa
```

Then inspect the slowest entries in the log.

## Likely hotspots

- `lua/config/dashboard.lua` because it owns dashboard rendering
- `lua/config/statusline.lua` because it owns git refresh and statusline work
- Tree-sitter installation and updates on first setup
- Blink's Rust build step after install or update
- markdown preview install step after install or update

## Low-risk tuning ideas

- reduce the default Tree-sitter parser list if you only need a smaller set
- shorten or simplify dashboard rendering if startup UI becomes too heavy
- reduce statusline sections or git refresh frequency if redraws feel heavy

## What not to assume

- there is no `StartupTime` plugin in this repo
- there is no `lualine` / `noice` / `snacks` stack to optimize away
