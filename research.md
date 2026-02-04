---
description: Research before planning - new features, debugging, exploration, refactoring
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task
---

# Research

Entry point for all new work. Investigate before planning.

## What This Covers

- New features (how to build, what exists)
- Debugging (root cause investigation)
- Exploration (understanding a domain)
- Refactoring (approaches, tradeoffs)
- Any investigation needed before creating a plan

## Phase 1: Assess

Analyze $ARGUMENTS. Determine:

1. **What kind of research is needed?**
2. **Is the topic multi-faceted (benefits from multiple perspectives)?**

| If the work involves... | Methodology |
|-------------------------|-------------|
| How to build something | @~/.claude/commands/scout/technical.md |
| Finding existing libraries/tools | @~/.claude/commands/scout/open-source.md |
| Can we actually do this? | @~/.claude/commands/scout/feasibility.md |
| Deep understanding of a topic | @~/.claude/commands/scout/deep-dive.md |
| How competitors/others solve it | @~/.claude/commands/scout/competitive.md |
| Understanding a space/market | @~/.claude/commands/scout/landscape.md |
| What's been tried before | @~/.claude/commands/scout/history.md |
| Comparing multiple options | @~/.claude/commands/scout/options.md |
| Debugging/investigation | @~/.claude/commands/scout/technical.md (focus on root cause) |

### Decision: Single vs Parallel

**Narrow/specific topic** → Single scout
- "How do I use ROS2 force-torque sensor?"
- "What's the API for library X?"
- Debugging a specific issue

**Broad/multi-faceted topic** → Parallel scouts (2-3 max)
- "Best approach for impedance control on UR5e" → technical + open-source + history
- "Should we use MPC or PID?" → options + technical
- "Add real-time data streaming" → technical + open-source + feasibility

## Phase 2: Execute

### If Single Scout

Read the methodology file and follow it completely. It has:
- Intake questions to clarify scope
- Process steps
- Output format

Adapt the methodology to the specific topic.

### If Parallel Scouts

Spawn 2-3 scouts in parallel using Task tool:

```
For each selected methodology:
- Use Task tool with subagent_type: "general-purpose"
- Prompt: "You are a research agent. Follow this methodology completely for the topic: [topic].
  Methodology: [read and include the scout file content].
  Return structured findings."
- Run scouts in parallel (single message with multiple Task calls)
```

Each scout investigates independently with its own context.

After all scouts complete, synthesize:
1. Read all scout findings
2. Identify overlaps and unique insights
3. Resolve contradictions
4. Create unified strategic summary

## Phase 3: Output

Save findings to `docs/plan/RESEARCH.md` in the current project directory.

Create the directory if it doesn't exist.

### Output Format

```markdown
## Original Intent
[What user asked, verbatim - one line]

## Evolved Understanding
[What we now know. How understanding shifted from original intent.
Synthesis, not journey - just bookends.]

## Key Findings
[Synthesized if parallel scouts were used]

## Recommendations
[What to do given the findings]

## Handoff to Planning
[What the plan should address. Clear bridge from research to /plan.]

## Sources
[References used]
```

If parallel scouts were used, note which methodologies were applied after Sources.

## Multi-Session Support

Research can span multiple sessions:
- Use /pause to save state
- Use /resume to continue
- RESEARCH.md accumulates findings

## Success Criteria

- Topic correctly assessed as narrow or broad
- Appropriate methodology(ies) selected
- If parallel: scouts ran concurrently, findings synthesized
- Original intent captured (bookend: where we started)
- Evolved understanding synthesized (bookend: where we ended up)
- Handoff to planning is clear (bridge to /plan)
- Output saved to docs/plan/RESEARCH.md
