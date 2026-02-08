---
description: Generate or update architecture diagrams at emergent abstraction levels
argument-hint: [scope or module to map]
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

## What exists already?

If `docs/diagrams/` and CLAUDE.md "Deep Dive References" exist → update mode (compare against code, report accurate/outdated/missing, user selects what to update). Otherwise → fresh mode.

## What are the natural layers?

Explore codebase via subagents. Propose abstraction levels that naturally emerge (2 for small codebases, up to 5 for complex). Present to user via the ask_user_question tool.

## What goes in each diagram?

One subagent per diagram, parallel where possible. Use exact function/class/variable names from code. Max 60 nodes per diagram — split if larger.

Diagram format — file `docs/diagrams/{name}.md`:

    # {Title}
    {One sentence: what this shows and when to read it.}
    ```mermaid
    {content}
    ```

## Where does it all live?

Update "Deep Dive References" in CLAUDE.md with level table linking `[[name]]` to `docs/diagrams/name.md`. Keep `[[wiki-links]]` stable across updates.
