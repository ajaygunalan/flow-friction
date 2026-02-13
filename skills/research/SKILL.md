---
description: Investigate anything — debugging, features, refactoring, decisions, exploration
argument-hint: <query or file path>
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task, Bash
---

# Research: $ARGUMENTS

$ARGUMENTS is mandatory.

You are an orchestrator. Stay lightweight — spawn subagents for heavy reading and searching, collect results, synthesize, talk to the user. Do NOT bulk-investigate yourself.

**Start immediately. Check in early.** Investigate first, then present early findings and confirm direction. Always bring findings with questions — never just questions.

**Ask often.** Uncertain about scope? Ask. Found something unexpected? Ask. Multiple paths? Ask. The user drives.

## Resume or Begin

- **File path** → spawn a subagent to read it. Understand where we left off and what gaps remain.
- **Query** → new topic. Read the project's CLAUDE.md so you know what already exists.

## The Loop

1. **Spawn subagents** in parallel for independent investigation lines:
   - `Explore` agents — codebase searching, file discovery, pattern matching
   - `general-purpose` agents — reading files, web searches, running commands, deeper analysis
   - Each subagent gets a focused prompt: file paths, context, constraints from prior rounds, and a specific deliverable
2. **Synthesize** — distill subagent results into a clear summary
3. **Ask the user** — dig deeper? pivot? enough?
4. **Repeat** until done

If the query implies a decision or comparison, spawn agents with competing perspectives and synthesize the strongest position.

Subagents must cite specific files and lines — no shallow analysis. Trivial checks — just do it yourself. Pass constraints from prior rounds into new subagent prompts. No fixed investigation structure — adapt to context.

## Persist

Write findings to `docs/research/<slug>.md` if the user asks. Top sections = current truth (rewrite each iteration, remove disproven). Iterations section = append-only history (what changed, 3-5 lines per round). Mark confirmed vs hypothesis where it naturally matters.

Report: file path + top insight, 2-3 lines.
