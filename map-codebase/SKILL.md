---
description: Generate or update architecture diagrams at emergent abstraction levels
argument-hint: [scope or module to map]
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

Generate or update mermaid diagrams in `docs/diagrams/`. If `docs/diagrams/` and CLAUDE.md "Deep Dive References" exist → update mode (compare against code, report accurate/outdated/missing, user selects what to update). Otherwise → fresh mode.

Explore codebase via subagents, then propose abstraction levels that naturally emerge (2 for small codebases, up to 5 for complex). Present to user via AskUserQuestion. One subagent per diagram, parallel where possible.

Diagram format — file `docs/diagrams/{name}.md`:
```
# {Title}
{One sentence: what this shows and when to read it.}
```mermaid
{content}
```
```

Update "Deep Dive References" in CLAUDE.md with level table linking `[[name]]` to `docs/diagrams/name.md`. Use exact function/class/variable names from code. Keep `[[wiki-links]]` stable across updates. Max 60 nodes per diagram — split if larger.
