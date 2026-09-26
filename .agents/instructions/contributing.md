# Commits and Agent Conduct

This project strictly follows **Conventional Commits** and the **50/72 rule**.

## Format

```
<type>(<scope>): <subject>

<body>
```

## Types

- `feat` – new feature
- `fix` – bug fix
- `refactor` – internal change without behavior change
- `perf` – performance improvement
- `docs` – documentation only
- `chore` – maintenance
- `test` – tests

## Scope Examples

- `config`
- `plugins`
- `autocmds`
- `keymaps`
- `diagnostics`

## Examples

```
feat(plugins): add treesitter via vim.pack

Improves syntax highlighting and enables incremental parsing.
```

```
refactor(keymaps): remove wrapper helper

Use direct vim.keymap.set calls for clarity and consistency.
```

## 50/72 Rule

- Subject line ≤ 50 characters
- Body lines wrapped at 72 characters
- Use actual line breaks in commit bodies, never literal `\n`
- Use imperative mood
- When using Pi's `commit_changes`, pass the exact commit text through
  `verbatim` and inspect `git log -1` afterward. Do not rely on its generated
  summary for commits that must match an established repository style.

## Docs Sync

On every commit, check if `AGENTS.md` or `README.md` need updates to reflect
the change. Update if content drifts from code reality.

## Agents SHOULD

- Prefer removing code over adding code
- Question every dependency
- Keep changes small and focused
- Document non-obvious decisions
- Align with existing structure before introducing new patterns

## Agents MUST NOT

- Add another plugin manager
- Reintroduce `lazy.vim`
- Introduce heavy abstraction layers
- Mix unrelated changes in one commit
- Ignore commit conventions
