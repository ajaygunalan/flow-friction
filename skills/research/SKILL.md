---
name: research
description: Research before planning - new features, debugging, exploration, refactoring, decisions
argument-hint: <file path or topic>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, Teammate, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, WebFetch, WebSearch
---

# Research: $ARGUMENTS

$ARGUMENTS is mandatory.

You are an **orchestrator**. Stay lightweight — spawn subagents for heavy reading and searching, collect results, synthesize, and talk to the user. Do NOT bulk-investigate yourself.

## Phase 1: Orient

Determine entry point from `$ARGUMENTS`:

- **File path** (e.g., `docs/research/rerun-query-crash.md`) → Spawn a subagent to read the existing file. Perform a **gap analysis**: identify what's confirmed, what's still open, and what may have changed. Present a short summary — "Here's where we left off: X is confirmed, Y and Z are still open" — then ask the user where to continue.
- **Query** (e.g., "rerun query crash") → New topic. Derive slug from query (→ `rerun-query-crash.md`). Read the project's `CLAUDE.md` so you know what already exists.

**Lightweight investigation first.** Before your first check-in, do quick initial work — read the target file, scan surrounding context, check obvious references (~30 seconds of effort). Come to the user with **informed questions and early findings**, not blank questions.

Then use **AskUserQuestion** — confirm what they want to investigate and what to focus on. Bug? Feature exploration? Architecture decision? Restructuring survey? Let the user shape the direction.

**Do NOT spawn heavy parallel work until direction is confirmed.**

## Phase 2: Investigate (iterative loop)

Each round:

1. **Spawn subagents** in parallel for independent investigation lines:
   - `Explore` agents — codebase searching, file discovery, pattern matching
   - `general-purpose` agents — reading multiple files, web searches, running commands, deeper analysis
   - Each subagent gets a focused prompt: file paths, context, constraints from prior rounds, and a specific deliverable
   - **Quality standard:** subagents must cite specific files and lines — no shallow analysis

2. **Synthesize** — collect subagent results, distill into a clear summary for the user.

3. **Check in at meaningful decision points** — use **AskUserQuestion** when the research direction could fork, when something unexpected surfaces, or when you need the user to prioritize. Use judgment for small calls (which file to read first); surface decisions that change direction (which hypothesis to pursue). Quality of check-ins over quantity.

4. **Repeat** until the user says we have enough or the research reaches a natural conclusion.

### Choosing the right tool: Subagents vs. Agent Teams

**Default to subagents** (`Task`) for standard research — file reading, pattern searching, code tracing, gathering information. They're fast, focused, and cost-efficient.

**Escalate to agent teams** (`Teammate`, `SendMessage`, `TaskCreate`, `TaskUpdate`, `TaskList`, `TaskGet`) when the task benefits from inter-agent communication:
- **Debugging with competing hypotheses** — teammates test different theories in parallel, challenge each other's assumptions, and converge on the strongest explanation. This avoids anchoring bias from sequential investigation.
- **Decision or comparison queries** — spawn teammates with competing perspectives. Each argues for a different approach. Synthesize the strongest position from the debate.
- **Cross-layer coordination** — changes spanning frontend, backend, and tests where agents need to share discoveries mid-task.

Agent teams are best suited for tasks where parallel exploration and inter-agent debate add real value. For routine research, subagents are the right tool.

### Guardrails

- If you can test something in 10 seconds yourself, just do it. Don't spawn a subagent for a trivial check.
- Pass constraints from prior rounds into subagent prompts (e.g., "DO NOT run how_to_query.py — it OOM-kills the machine").
- No fixed investigation structure. Adapt to context — trace code for bugs, survey files for restructuring, compare options for new features, whatever fits.

## Phase 3: Document

**Proactively offer to document when the research feels complete.** Don't wait for a specific trigger phrase — when the key questions are answered, suggest: "I think we've covered the main ground. Want me to document this to `docs/research/`?"

Write to `docs/research/<topic-slug>.md`. Create `docs/research/` if needed.

**Use this template by default.** For lightweight investigations, a trimmed version is fine as long as the core principles hold: top sections = current truth, iterations = append-only.

**Top sections = current truth.** Rewrite every iteration to reflect what you know NOW. Remove anything disproven. Gets cleaner over time.

**Iterations section = append-only history.** Short log (3-5 lines) of what changed per iteration. Only section that grows.

```markdown
---
status: iteration 1
topic: <topic name>
---

# Research: <Topic>

**Status:** Iteration N | **Date:** YYYY-MM-DD

## What are we investigating?

## What do we know?

## What don't we know?

## So what do we do?

## Sources
- [Source Title](URL) - Brief description

## Iterations

### Iteration 1
<What was learned, 3-5 lines>
```

### Update Rules

- `status` in frontmatter: `iteration N` while ongoing, `complete` when done.
- On continuation: rewrite top sections as current truth. Retracted findings noted in the iteration log. Bump iteration number.
- Mark findings as confirmed vs hypothesis where it naturally matters — don't force it when it doesn't apply.

## Phase 4: Report

File path + top insight. 2-3 lines max. This is the final handoff — a crisp summary the user can act on.
