---
name: write-specs
description: Decompose research blueprint into self-contained spec files via multi-round team debate — one file per piece, ready for /implement
allowed-tools: TeamCreate, TeamDelete, SendMessage, Task, TaskCreate, TaskUpdate, TaskList, TaskGet, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Write Specs

## Prerequisite

All three must exist in `docs/research/`:
- `what-to-build.md` (sharp, with Q structure)
- `how-to-test.md`
- `how-to-build.md`

If any missing, tell the user which skill to run and stop:
- Missing `what-to-build.md`: "Run `/brain-dump <your topic>` first."
- Missing `how-to-test.md`: "Run `/plan-tests` first."
- Missing `how-to-build.md`: "Run `/plan-build` first."

## What this produces

`docs/specs/` — one self-contained spec file per piece, ready for `/implement`.

## Steps

### 1. Read and reflect

Read all three research docs. Reflect back to user: "I see N pieces across L layers. Here's my read." Brief summary.

Also confirm output directory: "Spec files will go to `docs/specs/`. Want a different location?" Wait for user confirmation before proceeding.

### 2. Team lead writes the drafts

The team lead (you) writes the initial draft spec files directly — no need to spawn an agent for this. You already read the research docs.

1. Create `docs/specs/` directory
2. Write one file per piece from how-to-build.md, named `spec-{id}-{slug}.md` (lowercase kebab-case, e.g., `spec-1a-usstream.md`)
3. Use this template:

```
# Spec {ID}: {Name}

> Layer {N} — depends on: {list or "none"}

## What & Why
{2-3 sentences from what-to-build.md — the research question this serves}

## What to build
{Concrete: files to create/modify, classes/functions to add, CLI flags}

## How to build
{Step by step — what AI does, referencing existing patterns in the codebase}

## Test criteria
{From how-to-test.md — pass/fail, failure modes, what to log}

## Human vs AI
{Who does what. If hardware needed: exact CLI command for human. If pure code: AI does everything.}

## References
- what-to-build.md: {section}
- how-to-test.md: {test number}
- how-to-build.md: {section}
```

### 3. Create team and spawn 5 advocates

Only spawn advocates *after* drafts are written. No moderator agent needed — team lead orchestrates directly.

```
TeamCreate: name = "write-specs"
```

Spawn 5 advocates via `Task` tool with `team_name: "write-specs"`, `subagent_type: "general-purpose"`.

Send each advocate a DM immediately after spawning with the draft location and findings path.

**scope:**
```
You are the SCOPE & BOUNDARIES advocate on the write-specs team.

Your lens: Is each spec self-contained? Clean interfaces between specs? What files does each touch? No overlap between specs? Could someone implement one spec without reading any other spec file?

Source files (read for context):
- docs/research/what-to-build.md
- docs/research/how-to-test.md
- docs/research/how-to-build.md

Spec files: docs/specs/spec-*.md

Protocol:
1. Read all spec files + research docs
2. Write your critique to docs/specs/_findings/round-1-scope.md
3. Message team-lead: "Critique written to docs/specs/_findings/round-1-scope.md"
4. Wait for team-lead's next round message. Do NOT re-send — one message per round.
5. If no issues remain, write "No changes needed" in your findings file and message team-lead once.
```

**codebase:**
```
You are the CODEBASE GROUNDING advocate on the write-specs team.

Your lens: Read the actual source code. Do specs match what's really in the codebase? Correct file paths, function names, class names, protocols? Does the existing code support what each spec assumes? Flag any spec that references something that doesn't exist or works differently than described.

Start by reading AGENTS.md for the file map, then read every source file that any spec references.

Source files (read for context):
- docs/research/what-to-build.md
- docs/research/how-to-test.md
- docs/research/how-to-build.md

Spec files: docs/specs/spec-*.md

Protocol:
1. Read all spec files + the actual source code files they reference
2. Write your critique to docs/specs/_findings/round-1-codebase.md
3. Message team-lead: "Critique written to docs/specs/_findings/round-1-codebase.md"
4. Wait for team-lead's next round message. Do NOT re-send — one message per round.
5. If no issues remain, write "No changes needed" in your findings file and message team-lead once.
```

**testability:**
```
You are the TESTABILITY advocate on the write-specs team.

Your lens: Is pass/fail concrete for each spec? Can AI verify it (unit test, script) or does it need a human at the robot? What exactly is the "done" signal? Is it binary or ambiguous? Could a new session pick up this spec and know if it's already done?

Source files (read for context):
- docs/research/what-to-build.md
- docs/research/how-to-test.md
- docs/research/how-to-build.md

Spec files: docs/specs/spec-*.md

Protocol:
1. Read all spec files + research docs
2. Write your critique to docs/specs/_findings/round-1-testability.md
3. Message team-lead: "Critique written to docs/specs/_findings/round-1-testability.md"
4. Wait for team-lead's next round message. Do NOT re-send — one message per round.
5. If no issues remain, write "No changes needed" in your findings file and message team-lead once.
```

**hitl:**
```
You are the HITL & DATA FLOW advocate on the write-specs team.

Your lens: What does the human actually do for each spec? What data flows out of one spec into the next? Are format handoffs explicit (file paths, data shapes, formats)? If spec A produces data spec B consumes, is that connection documented in both specs?

Source files (read for context):
- docs/research/what-to-build.md
- docs/research/how-to-test.md
- docs/research/how-to-build.md

Spec files: docs/specs/spec-*.md

Protocol:
1. Read all spec files + research docs
2. Write your critique to docs/specs/_findings/round-1-hitl.md
3. Message team-lead: "Critique written to docs/specs/_findings/round-1-hitl.md"
4. Wait for team-lead's next round message. Do NOT re-send — one message per round.
5. If no issues remain, write "No changes needed" in your findings file and message team-lead once.
```

**risk:**
```
You are the RISK & FALLBACK advocate on the write-specs team.

Your lens: What if each spec fails? What assumptions might not hold? Are there escape hatches? If a spec's approach doesn't work, does the spec say what to try instead? Flag specs that assume something unverified.

Source files (read for context):
- docs/research/what-to-build.md
- docs/research/how-to-test.md
- docs/research/how-to-build.md

Spec files: docs/specs/spec-*.md

Protocol:
1. Read all spec files + research docs
2. Write your critique to docs/specs/_findings/round-1-risk.md
3. Message team-lead: "Critique written to docs/specs/_findings/round-1-risk.md"
4. Wait for team-lead's next round message. Do NOT re-send — one message per round.
5. If no issues remain, write "No changes needed" in your findings file and message team-lead once.
```

### 4. Collect Round 1, synthesize, iterate

Team lead (you) orchestrates directly — no moderator agent.

1. Wait for all 5 advocates to message back with their findings paths
2. Read all 5 critique files from `docs/specs/_findings/`
3. Resolve conflicts — update the spec files directly
4. If issues were found: send 5 DMs to advocates: "Updated spec files. Round 2 — any remaining issues? Write to docs/specs/_findings/round-2-{your-lens}.md"
5. Repeat until all advocates respond "no changes needed" or max 5 rounds

Track which advocates have responded each round. Don't re-notify advocates who already replied.

### 5. Clean up

1. Delete `docs/specs/_findings/` directory
2. Send `shutdown_request` to all 5 advocates
3. Call `TeamDelete`

### 6. Review with user

AskUserQuestion: "Here are the spec files. Revise or accept?"

## Commit

```
git add docs/specs/ && git commit -m "write-specs: self-contained spec files from research blueprint"
```

## Next

"Pick a spec and run `/implement` on it. Start from Layer 1."
