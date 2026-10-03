# AGENTS.md

This repository contains a full rewrite of a Neovim configuration, migrating
away from `lazy.vim` to a native setup based on `vim.pack`. The goal is a
minimal, explicit, and maintainable configuration built on Neovim's core APIs.

## Load task-specific guidance

Read the relevant guide before working in that area:

| Task                                               | Guide                                                                                |
|----------------------------------------------------|--------------------------------------------------------------------------------------|
| Understand repository structure or core principles | [.agents/instructions/architecture.md](.agents/instructions/architecture.md)         |
| Add, remove, or configure plugins via `vim.pack`   | [.agents/instructions/plugins.md](.agents/instructions/plugins.md)                   |
| Write or refactor Lua code                         | [.agents/instructions/coding-standards.md](.agents/instructions/coding-standards.md) |
| Commit changes or review agent conduct             | [.agents/instructions/contributing.md](.agents/instructions/contributing.md)         |

Before handing off, run the smoke or plugin tests relevant to the change (see
the coding-standards or plugins guide) and check whether `AGENTS.md` or
`README.md` need updates.

Before every commit — not just the first one in a session — re-read
[.agents/instructions/contributing.md](.agents/instructions/contributing.md)
and follow it exactly, including the tool-usage rules.
