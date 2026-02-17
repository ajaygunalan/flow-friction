---
name: investigate
description: Autonomous investigation — spawn subagents, trace code, find answers, report back
argument-hint: <file path or topic>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, Teammate, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, WebFetch, WebSearch
---

# Investigate: $ARGUMENTS

$ARGUMENTS is mandatory.

You are an **autonomous investigator**. Spawn subagents for heavy reading and searching, collect results, synthesize, and report findings to the user. Do NOT check in with AskUserQuestion during investigation — go dig, come back with answers.

## Phase 1: Check for existing scratchpad

Derive slug from `$ARGUMENTS` (file path → filename without extension, query → kebab-case).

- **Scratchpad exists** at `docs/research/<slug>.md` → Spawn a subagent to read it. Identify what's confirmed, what's ruled out, what's still open. Continue from where it left off.
- **No scratchpad** → Fresh investigation. Read the project's `CLAUDE.md` so you know what already exists.

## Phase 2: Investigate

Spawn subagents in parallel for independent investigation lines:

- `Explore` agents — codebase searching, file discovery, pattern matching
- `general-purpose` agents — reading multiple files, web searches, running commands, deeper analysis
- Each subagent gets a focused prompt: file paths, context, constraints from prior rounds, and a specific deliverable
- **Quality standard:** subagents must cite specific files and lines — no shallow analysis

Collect results, identify gaps, spawn follow-up subagents as needed. Repeat until the key questions are answered.

### Choosing the right tool: Subagents vs. Agent Teams

**Default to subagents** (`Task`) for standard research — file reading, pattern searching, code tracing, gathering information. They're fast, focused, and cost-efficient.

**Escalate to agent teams** (`Teammate`, `SendMessage`, `TaskCreate`, `TaskUpdate`, `TaskList`, `TaskGet`) when the task benefits from inter-agent communication:
- **Debugging with competing hypotheses** — teammates test different theories in parallel, challenge each other's assumptions, and converge on the strongest explanation.
- **Decision or comparison queries** — spawn teammates with competing perspectives. Each argues for a different approach. Synthesize the strongest position.
- **Cross-layer coordination** — changes spanning multiple layers where agents need to share discoveries mid-task.

When escalating to agent teams, follow the `ensemble` skill for setup and execution patterns.

### Guardrails

- If you can test something in 10 seconds yourself, just do it. Don't spawn a subagent for a trivial check.
- Pass constraints from prior rounds into subagent prompts (e.g., "DO NOT run how_to_query.py — it OOM-kills the machine").
- No fixed investigation structure. Adapt to context — trace code for bugs, survey files for restructuring, compare options for decisions, whatever fits.

## Phase 3: Update scratchpad

Write or update `docs/research/<slug>.md`. Create `docs/research/` if needed.

Lightweight format — this is a working scratchpad, not a deliverable:

```markdown
# <Topic>

**Updated:** YYYY-MM-DD

## Hypothesis
<current best understanding>

## Confirmed
<what we know for sure, with file:line citations>

## Ruled out
<what we eliminated and why>

## Still need to check
<open threads for next investigation>
```

On continuation: rewrite Hypothesis/Confirmed/Ruled out as current truth. Append new items to "Still need to check" or move them to Confirmed/Ruled out.

## Phase 4: Report

Present findings to the user. File path + key findings. Crisp summary they can act on — what you confirmed, what you're inferring, and what's still open.
