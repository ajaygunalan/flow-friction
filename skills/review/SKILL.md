---
description: Code review with configurable thoroughness - completes analysis before any fixes
argument-hint: [files or scope to review]
allowed-tools: Read, Glob, Grep, Task, AskUserQuestion
---

## How deep should this go?

Ask thoroughness level upfront via AskUserQuestion:
- **Quick** — structure, obvious issues
- **Standard** — architecture, patterns
- **Exhaustive** — edge cases, tests, security, performance

## What's actually in the code?

Read all files in scope. Map dependencies. Complete ALL analysis before suggesting any fixes.

## What are the problems?

Output a summary table: severity, location, issue. Then detailed analysis for each.

## What should change?

Recommendations — only after the full review is documented. Never start fixing until the review is complete.
