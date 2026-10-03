# Commits and Agent Conduct

This project strictly follows **Conventional Commits** and the **50/72 rule**.

> [!IMPORTANT]
> Read this file in full BEFORE calling any commit tool, every time —
> not just the first time in a session. When using Pi's `commit_changes`,
> always pass the exact, already-formatted `<type>(<scope>): <subject>`
> message through `verbatim`. Never use the plain `message` field: it
> lets the tool auto-generate/summarize the text, which silently
> discards Conventional Commits formatting and the 50/72 rule.

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
- When using Pi's `commit_changes`, always pass the exact commit text
  through `verbatim`. Never use the plain `message` field — it lets the
  tool auto-generate/summarize the text, which can produce a garbled
  subject and body unrelated to what was intended.
- Before composing a message for a given `<type>(<scope>)`, search history
  (e.g. `git log --grep` or scanning recent matching commits) for that
  type's existing subject and body conventions, and match them — including
  whether a body is expected and what it typically lists.
- After committing, always run `git log -1 --pretty=full` and compare the
  result against the convention found above before considering the commit
  done. Do not rely on the tool's own report of success.

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
- Call `commit_changes` with the plain `message` field instead of
  `verbatim`
