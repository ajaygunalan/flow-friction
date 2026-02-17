---
name: ensemble
description: Orchestrate multi-agent teams for debates, parallel implementation, research swarms, and review panels. Use when a task benefits from multiple perspectives working in parallel — evaluating competing approaches, optimizing documents, resolving design decisions, parallel coding, or coordinated research.
---

# Ensemble

## When to Use

- **Debate**: Evaluate competing approaches through structured advocate rounds
- **Parallel implementation**: Split a feature across frontend/backend/test agents
- **Research swarm**: Multiple agents explore different angles simultaneously
- **Review panel**: Multiple lenses critique the same artifact

## Setup Checklist

Before spawning any teammates:

1. **Define evaluation buckets** — What dimensions matter? Name each one. Common buckets:
   - Executability (can instructions be followed?)
   - Integrity (do systems stay coherent?)
   - Data quality (does output stay useful over time?)
   - Identity (does the system know what it has?)
   - Performance, Security, Maintainability, etc.

2. **Get user approval on buckets** — Use AskUserQuestion or EnterPlanMode. Missing a bucket wastes the entire run. The user knows their domain; you don't.

3. **Create a shared state file** — Write the initial artifact (draft, spec, code) to a file all agents can read. Never pass full documents in messages — pass file paths.

4. **Create tasks with dependencies** — Use TaskCreate + TaskUpdate(addBlockedBy) to enforce round ordering:
   ```
   Round 1 tasks: parallel, no dependencies
   Round 2 tasks: blockedBy Round 1
   Synthesis task: blockedBy all rounds
   ```

## Spawning Pattern

### Debate (advocate + moderator)

One agent per evaluation bucket + one moderator.

**Moderator's first job**: Write a plan specifying evaluation criteria, convergence condition, and max rounds. Get plan approved by team lead before starting rounds.

**Each advocate**: Reads shared file, critiques from their bucket's lens, writes critique to shared findings file (not just messages).

**Round flow**:
1. Moderator writes draft to shared file
2. Moderator messages advocates: "Draft at /path/file.md — please critique"
3. Advocates write critiques to `/path/round_N_findings.md`
4. Advocates message moderator: "Critique written to findings file"
5. Moderator reads findings, resolves conflicts, updates draft
6. Repeat until convergence or max rounds

**Convergence**: Stop when no advocate raises issues above severity threshold, or max rounds hit.

### Parallel implementation

One agent per component. Shared interface file defines contracts.

### Research swarm

One agent per hypothesis/angle. Shared findings document accumulates results.

## Communication Rules

- **Direct message** (`type: "message"`) for 1:1 communication — always preferred
- **Broadcast** (`type: "broadcast"`) only for blocking issues that affect everyone
- **Shared files** for persistent state — messages can be missed, files can't
- **Short messages** — say "critique written to /path/findings.md" not the full critique text
- **Task updates** — mark tasks completed when done, check TaskList for next work

## Anti-Patterns

| Don't | Do Instead |
|-------|-----------|
| Pass full documents in messages | Write to shared file, send file path |
| Assume messages were received | Check if agent responded; resend once if needed |
| Create tasks without dependencies | Use addBlockedBy to enforce ordering |
| Start debate without bucket approval | Get user sign-off on evaluation dimensions first |
| Let moderator self-define criteria | Moderator submits plan for approval before Round 1 |
| Run indefinitely | Set max rounds (5-8 for debates) |
| Broadcast every update | Direct message the specific agent who needs it |
| Treat idle as broken | Idle = waiting for input, completely normal |

## Shutdown

When work is complete:
1. Moderator sends final summary to team lead
2. Team lead reviews output
3. Team lead sends shutdown_request to each agent
4. Team lead calls TeamDelete to clean up

## Template: Debate Spawn Prompts

**Moderator**:
```
You are the MODERATOR. You have N advocates: [names].
1. Read the shared artifact at [path]
2. Write your evaluation plan (buckets, convergence criteria, max rounds) to [path]
3. Wait for team lead approval
4. Run rounds: send draft path to advocates, collect critiques from findings file, resolve conflicts, update draft
5. When converged: write final to [output path], message team lead
```

**Advocate**:
```
You are the [BUCKET] advocate. Your lens: [one-sentence description].
Sub-criteria: [list specific things to check].
1. Read all source files
2. Claim your task from TaskList
3. Wait for moderator to send draft path
4. Write critique to shared findings file
5. Message moderator when done
```
