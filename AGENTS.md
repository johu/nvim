# AGENTS.md

## Purpose

This repository contains a full rewrite of a Neovim configuration, migrating away from `lazy.vim` to a native setup based on `vim.pack` (introduced in Neovim 0.12).

The goal is a minimal, explicit, and maintainable configuration built on Neovim’s core APIs.

---

## Core Principles

### Native First

- Prefer `vim.*` APIs over plugins whenever possible.
- Use `vim.pack` as the only plugin management mechanism.
- Do not introduce alternative plugin managers or abstraction layers.

### Minimalism

- Every dependency must have a clear, justified purpose.
- Prefer small in-repo Lua implementations over plugins when feasible.
- Avoid feature creep.

### Explicitness

- No hidden behavior or “magic”.
- Configuration should be easy to trace and reason about.
- Avoid implicit side effects across modules.

### Maintainability

- Optimize for long-term clarity, not short-term convenience.
- Keep modules small, readable, and focused.

---

## Repository Structure

```text
.
├── init.lua
├── lua/
│   ├── config/
│   │   ├── init.lua
│   │   ├── autocmds.lua
│   │   ├── diagnostics.lua
│   │   ├── health.lua
│   │   ├── keymaps.lua
│   │   └── options.lua
│   └── plugins/
│       ├── init.lua
└── nvim-pack-lock.json
```

### Guidelines

- `init.lua` is the single entry point and should remain concise.

- `lua/config/` contains core Neovim configuration:
  - `init.lua` → loads core config modules
  - `options.lua` → `vim.opt`
  - `keymaps.lua` → `vim.keymap.set`
  - `autocmds.lua` → `vim.api.nvim_create_autocmd`
  - `diagnostics.lua` → `vim.diagnostic`
  - `health.lua` → custom checks (optional but encouraged)

- `lua/plugins/` contains:
  - `init.lua` → loads plugin modules
  - Plugin declarations via `vim.pack`
  - Plugin-specific configuration

- `nvim-pack-lock.json` must be committed and kept in sync.

---

## Plugin Management

- All plugins must be added via `vim.pack`.
- Do not reintroduce `lazy.vim` or similar tools.
- Avoid excessive lazy-loading unless it provides measurable benefit.

### Rules

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

---

## Coding Standards

### Lua

- Use idiomatic Lua
- Prefer `local` over globals
- Avoid unnecessary abstraction layers
- Keep functions small and composable

### File Organization

- Do not create new top-level directories without strong justification
- Avoid deep nesting
- Group related logic, but don’t overload single files

---

## Commit Guidelines

This project strictly follows **Conventional Commits** and the **50/72 rule**.

### Format

```
<type>(<scope>): <subject>

<body>
```

### Types

- `feat` – new feature
- `fix` – bug fix
- `refactor` – internal change without behavior change
- `perf` – performance improvement
- `docs` – documentation only
- `chore` – maintenance
- `test` – tests

### Scope Examples

- `config`
- `plugins`
- `autocmds`
- `keymaps`
- `diagnostics`

### Examples

```
feat(plugins): add treesitter via vim.pack

Improves syntax highlighting and enables incremental parsing.
```

```
refactor(keymaps): remove wrapper helper

Use direct vim.keymap.set calls for clarity and consistency.
```

### 50/72 Rule

- Subject line ≤ 50 characters
- Body lines wrapped at 72 characters
- Use imperative mood

### Docs Sync

On every commit, check if `AGENTS.md` or `README.md` need updates to reflect the change. Update if content drifts from code reality.

---

## Agent Guidelines

### Agents SHOULD

- Prefer removing code over adding code
- Question every dependency
- Keep changes small and focused
- Document non-obvious decisions
- Align with existing structure before introducing new patterns

### Agents MUST NOT

- Add another plugin manager
- Reintroduce `lazy.vim`
- Introduce heavy abstraction layers
- Mix unrelated changes in one commit
- Ignore commit conventions

---

## Decision Heuristics

When making changes, prefer:

1. Built-in Neovim functionality over plugins
2. Simplicity over flexibility
3. Explicit code over implicit behavior
4. Fewer dependencies over more features

---

## Notes

- This configuration is meant for long-term use, not experimentation.
- Complexity is a liability—treat it as such.
- If something feels “clever”, it’s probably not appropriate here.
