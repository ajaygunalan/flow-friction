---
description: Code review with configurable thoroughness - completes analysis before any fixes
argument-hint: [files or scope to review]
allowed-tools: Read, Glob, Grep, Task, AskUserQuestion
---

Ask thoroughness level upfront: Quick (structure, obvious issues), Standard (architecture, patterns), or Exhaustive (edge cases, tests, security, performance).

Complete ALL analysis before suggesting fixes — read all files, map dependencies, identify every issue first. Output: summary table (severity, location, issue), then detailed analysis, then recommendations. Never start fixing until the full review is documented.
