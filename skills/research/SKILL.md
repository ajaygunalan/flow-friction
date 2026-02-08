---
description: Research before planning - new features, debugging, exploration, refactoring
argument-hint: [topic to investigate]
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task, TaskCreate, TaskList, TaskUpdate, TaskGet, TeamCreate, TeamDelete, SendMessage
---

# Research: $ARGUMENTS

## 1. Check for Existing Research

Scan `docs/research/` for all `.md` files. Parse YAML frontmatter to find **active** files (any `status` that is NOT `complete`).

To find active research files (frontmatter-only parsing, ignores body content):
```bash
awk '/^---/{c++; next} c==1 && /^status:/ && !/complete/{print FILENAME}' docs/research/*.md 2>/dev/null
```

- **0 active** → New topic. Derive a slug from `$ARGUMENTS` (e.g., "rerun query crash" → `rerun-query-crash.md`). This is Iteration 1. Create `docs/research/` directory if it doesn't exist.
- **1 active** → Continue that file. Read current findings, note the iteration number. Treat `$ARGUMENTS` as the user's new direction or feedback. Agents must read existing findings and investigate gaps, not redo work.
- **2+ active** → Use **AskUserQuestion** to ask which one to continue, or whether to start a new topic. List each active file with its topic and current iteration.

Override: if `$ARGUMENTS` clearly describes a new topic unrelated to any active file, start a new file regardless of active count.

## 2. Analyze the Research Question

Based on `$ARGUMENTS` and any existing findings, determine what needs investigating. Identify relevant files from the project that agents will need to examine.

## 3. Propose Team Composition

Use **AskUserQuestion** to propose a team. Analyze the research question and suggest agents with roles tailored to the problem:

- Determine how many agents the problem needs (could be 1, could be 5+)
- Invent role names that fit the problem (not from a fixed menu)
- Describe what each agent will investigate and deliver

Example question: "I think this needs 3 agents: `api-tracer` to trace the query pipeline, `sdk-auditor` to verify SDK compatibility, `docs-checker` to compare docs vs code. Adjust?"

The user confirms, adjusts count, or changes roles.

## 4. Spawn Team

```
TeamCreate: "research-<topic-slug>"
```

Create tasks via TaskCreate for each agent, then spawn teammates.

### Spawn Prompt Requirements

Every teammate gets ZERO conversation history. Their spawn prompt MUST include:

1. The research question and current iteration context
2. Relevant file paths from the project
3. Existing findings to build on (if continuing)
4. Their specific deliverable — not "investigate X" but "produce findings about X with file:line references"
5. Constraints from existing research (e.g., "DO NOT run how_to_query.py")
6. Debate instruction: "After completing your investigation, use SendMessage to challenge other teammates' findings if you see contradictions."

### Team Lifecycle

1. Create team and tasks via TaskCreate
2. Spawn teammates — they claim tasks via TaskUpdate, mark completed when done
3. Wait for all teammates to complete (read their messages as they come in)
4. Synthesize findings — resolve contradictions, merge into research file
5. Shutdown teammates via SendMessage (type: shutdown_request)
6. Delete team via TeamDelete

## 5. Write Research File

Write to `docs/research/<topic-slug>.md`. Use this format exactly:

```markdown
---
status: iteration 1
topic: <topic name>
---
# Research: <Topic>

**Status:** Iteration N | **Date:** YYYY-MM-DD

## Problem Statement

<Describe the problem and why it matters>

## Key Findings

<Summarize the most relevant solutions and approaches>

## Codebase Patterns

<Document how the current codebase handles similar cases>

## Recommended Approach

<Provide your recommendation based on all research>

## Sources

- [Source Title](URL) - Brief description

## Iterations

### Iteration 1
<Key learnings and discoveries from this round of investigation>

### Iteration 2
<What changed, what was confirmed or ruled out, new insights>
```

### Format Rules

- **YAML frontmatter**: Every research file has `status` and `topic` in frontmatter. Status is `iteration N` while ongoing, `complete` when done.
- **On continuation**: Update Key Findings, Codebase Patterns, Recommended Approach, and Sources in place as understanding evolves. Append new iteration at the bottom. Bump iteration number in both frontmatter (`status: iteration N`) and the body `**Status:**` line.
- **Iterations**: Oldest first, append new ones at the bottom. Each iteration captures key learnings from that round.

## 6. Report to User

After writing, output: the file path, how many findings, and what the top recommendation is. Keep it to 2-3 lines.
