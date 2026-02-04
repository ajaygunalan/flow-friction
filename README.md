# Flow-Friction

Solo research workflow for fast iteration

> Flow fast. Friction for what survives.
> Why plan 10 ideas when 9 will die? Explore first. Structure the survivor.

---

## What is a Meta-Prompting Framework?

AI coding assistants like Claude Code are powerful but unstructured. Without guidance, they jump straight into code, lose context across sessions, and produce inconsistent results.

A meta-prompting framework solves this by adding a layer of commands and conventions on top of the AI. Instead of just asking "build X", you use structured commands like `/plan`, `/research`, `/implement` that guide the AI through a deliberate process. The framework provides:

- Context management (diagrams, plans, session state)
- Structured workflows (research before coding, verification after)
- Thinking tools (frameworks for reasoning through decisions)

This is also called spec-driven development — you write specifications and plans before code, not after.

---

## The Problem with Existing Frameworks

Most meta-prompting frameworks copy enterprise software processes:

- Project initialization rituals
- State files tracking "current phase"
- Mandatory progression (plan → design → implement → verify)
- Sprint ceremonies, story tracking, audit trails

This works for teams shipping products. It fails for research.

Research is exploratory. Nine out of ten ideas die. You don't know what you're building until you've tried building it. Forcing upfront ceremony on experiments wastes time on plans that get abandoned.

---

## Flow-Friction's Approach

Invert the order. Explore first. Structure survivors.

Other workflows: ceremony first, then discover most ideas fail. Wasted plans.

Flow-Friction: explore first, structure what survives. No project init. No tracking files. No mandatory phases. Add plans only to ideas that earn them.

When something survives your experiments and proves worth building, then add friction — a plan, refinement, proper implementation. Structure follows discovery.

---

## Built For

Solo researchers in:

- Robotics
- Machine Learning
- Scientific Computing
- Data Science / Analytics
- Numerical Analysis
- Optimization
- Algorithm Development
- Game Development

Not for: Teams needing sprint tracking, enterprises needing audit trails, projects requiring upfront documentation.

---

## Enter Anywhere

```
┌─────────────────────────────────────────────────────────────┐
│                    WHAT YOU KNOW → WHERE TO START           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   "I know the fix"              →  Just ask Claude          │
│                                                             │
│   "I know the cause"            →  Just ask Claude          │
│                                                             │
│   "Something's wrong, not sure" →  /research (debug mode)   │
│                                                             │
│   "I know what to build"        →  /plan                    │
│                                                             │
│   "I need to understand first"  →  /research                │
│                                                             │
│   "I have a plan already"       →  /implement               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

No mandatory starting point. Your knowledge determines your entry.

---

## Command Dependencies

Some commands work alone. Others need a plan.

```
STANDALONE (entry points)          NEED A PLAN
─────────────────────────          ───────────

/research ──┐                      /refine ────► refines existing plan
            │
/plan ──────┼──────────────────►   /implement ─► executes plan tasks
            │
/map-codebase                      /verify ────► checks against plan


UTILITIES (use anytime)
───────────────────────
/pause          Save session state
/resume         Continue from saved state
/commit_and_push   Squash and push when ready
```

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/research` | Investigate unknowns - debugging, feasibility, approaches |
| `/plan` | Create implementation plan with tasks |
| `/refine` | Audit plan coverage against original request, patch gaps |
| `/implement` | Execute plan tasks via subagents with atomic commits |
| `/verify` | Check implementation matches the plan |
| `/map-codebase` | Generate level-based Mermaid diagrams |
| `/pause` | Save session state for later |
| `/resume` | Continue from saved state |
| `/commit_and_push` | Add [>>] checkpoint marker, push all commits |

---

## Common Flows

These are examples, not requirements. Mix and match based on what you know.

### Simple Fix
```
Ask Claude → Fix → Done

No commands needed. Claude has context via CLAUDE.md diagrams.
```

### Debug (cause unknown)
```
/research "why is sensor drifting"
    │
    ▼
Find root cause → Fix → Done

Research in debug mode finds the cause. Then just fix it.
```

### New Feature (you know what to build)
```
/plan "add force control"
    │
    ▼
/implement → /verify → Done

Skip research if you already know the approach.
```

### Complex Feature (need to understand first)
```
/research "force control approaches for UR5e"
    │
    ▼
/plan "implement impedance control"
    │
    ◄───────────────┐
    ▼               │
/refine ────────────┘ (iterate until solid)
    │
    ▼
/implement → /verify → Done
```

### Iterate on Existing Plan
```
/refine → /refine → /refine → solid plan → /implement

Multiple refinement rounds are normal. Keep going until gaps are filled.
```

---

## Level-Based Architecture Diagrams

`/map-codebase` generates Mermaid diagrams organized by abstraction level. Levels emerge from codebase complexity - could be 2, could be 5.

```
L1 -- Static Structure     │ What exists?           │ [[architecture]]
L2 -- Entry Points         │ How does it start?     │ [[cli_routing]]
L3 -- Data Flow            │ What happens per tick? │ [[dataflow]]
...                        │ ...                    │ ...
```

Each level assumes familiarity with the one above. CLAUDE.md references diagrams via `[[name]]` wiki links.

Why levels matter:
- Navigate by question type, not by file search
- Zoomed-out levels for orientation, zoomed-in for debugging

Why diagrams over prose:
- Spot errors instantly (wrong arrow = wrong dependency)
- Claude reads diagrams and navigates architecture immediately
- `/map-codebase` regenerates when code changes - no drift

---

## Why This Works

### Stateless Architecture

No "current phase" tracking. No mandatory sequence. No state files. Run any command anytime.

### Minimal Files

RESEARCH.md, plan.md, diagrams/ — that's it. Early mistake in 2 files = quick fix.

### CLAUDE.md Has Context

`/map-codebase` generates level-based diagrams → stored in `diagrams/` → CLAUDE.md has wiki links `[[name]]`.

Claude reads CLAUDE.md on every session. It already knows your architecture. No "discovery" phase needed.

### Conditional Parallel Research

`/research` assesses complexity:
- Narrow topic → single scout agent (fast)
- Broad topic → 2-3 parallel scouts → synthesize (thorough)

Based on [Anthropic's multi-agent research](https://www.anthropic.com/engineering/multi-agent-research-system).

### Intent Preservation

Research is sculpting — intent evolves as you discover. Flow-Friction captures bookends, not the journey:

- `/research` outputs Original Intent (where you started) and Evolved Understanding (where you ended up)
- `/refine` appends a Refinement Log showing what changed and why
- `/pause` synthesizes session state for handoff

Synthesis at transitions. No continuous tracking. Know where you started and where you are without context pollution.

### Coverage Audit

`/refine` compares the plan against the original request:
- Marks each requirement: Covered / Partial / Missing
- Outputs coverage score (0-100) with rationale
- Patches gaps with minimal changes
- Appends Refinement Log entry (coverage change, gaps patched)

### Trust Your Judgment

You decide the complexity. You choose the entry point. No gatekeeping.

---

## Commit Strategy

Two layers: atomic commits for AI traceability, checkpoint markers for human navigation.

```
/implement creates:
    ├── "Task 1: Add force sensor interface"
    ├── "Task 2: Implement PID controller"
    ├── "Task 3: Add safety limits"
    └── "Task 4: Add tests"

/commit_and_push adds:
    └── "[>>] Add force control to UR5e" (you choose) → Push all
```

Navigate history:
```bash
git log --oneline --grep="\[>>\]"     # Find checkpoints (human)
git log --oneline                      # Full atomic history (AI)
```

---

## Setup

### Minimal

Commands work immediately. Just use them.

### Recommended

Task Persistence - Tasks survive `/clear` and new sessions:
```bash
# Add to ~/.bashrc or ~/.zshrc
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

Project-Local Plans - Store in project, not ~/.claude/:
```json
{ "plansDirectory": "docs/plan/" }
```

Single Plan Enforcement - Auto-delete old plans, preserve research:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "FILE=$(jq -r '.tool_input.file_path'); DIR=$(dirname \"$FILE\"); echo \"$FILE\" | grep -q 'docs/plan/' && [ ! -f \"$FILE\" ] && find \"$DIR\" -maxdepth 1 -name '*.md' ! -name 'RESEARCH.md' -delete || true"
      }]
    }]
  }
}
```

Extended Thinking:
```json
{ "alwaysThinkingEnabled": true }
```

---

## Research Methodologies

`/research` auto-selects based on topic:

| Methodology | Use Case |
|-------------|----------|
| `scout/technical` | How to build something |
| `scout/open-source` | Finding existing libraries |
| `scout/feasibility` | Can we actually do this? |
| `scout/deep-dive` | Deep understanding |
| `scout/competitive` | How others solve it |
| `scout/landscape` | Understanding a space |
| `scout/history` | What's been tried before |
| `scout/options` | Comparing approaches |

---

## Thinking Frameworks

Standalone commands for structured reasoning. Use when you need a specific lens:

| Framework | Use For |
|-----------|---------|
| `think/inversion` | What would guarantee failure? |
| `think/first-principles` | Strip to fundamentals, rebuild |
| `think/second-order` | Consequences of consequences |
| `think/5-whys` | Drill to root cause |
| `think/pareto` | Find the 20% that matters |
| `think/opportunity-cost` | What you give up by choosing this |

Additional: `think/swot`, `think/via-negativa`, `think/occams-razor`, `think/one-thing`, `think/10-10-10`, `think/eisenhower-matrix`, `think/crucible`

---

## File Locations

| File | Purpose |
|------|---------|
| `docs/plan/RESEARCH.md` | Research findings |
| `docs/plan/*.md` | Plan files |
| `diagrams/*.md` | Level-based Mermaid diagrams |
| `RESUME.md` | Session handoff |
| `CLAUDE.md` | Project rules + diagram references |

---

## Example Session

```bash
# Simple fix - no commands needed
claude
> "The sensor reading is inverted, flip the sign"
                              # Claude knows codebase via CLAUDE.md
                              # Finds file, fixes, done

# Debug - cause unknown
claude
> /research "debug: robot arm overshoots target"
                              # Investigates, finds PID tuning issue
                              # Fix directly, no plan needed

# New feature - know what to build
claude
> /plan "add emergency stop button"
> /implement
> /verify
> /commit_and_push

# Complex feature - need research first
claude
> /research "force control approaches for UR5e"
> /pause                      # end of day

claude
> /resume
> /plan "implement impedance control"
> /refine                     # surfaces edge cases
> /refine                     # clarifies sensor requirements
> /implement                  # 5 atomic commits
> /verify
> /commit_and_push            # [>>] marker → push all
```

---

## Choosing a Workflow

Different tools for different needs:

- Flow-Friction: Solo researchers, fast iteration, minimal ceremony
- [GSD](https://github.com/glittercowboy/get-shit-done): Want guardrails, structured phase tracking, team coordination
- [BMAD](https://github.com/bmad-code-org/BMAD-METHOD): Enterprise, sprint/story tracking, audit trails
- [Agent OS](https://github.com/ajaygunalan/agent-os): Standards documentation, team onboarding, pattern extraction

---

## Inspiration

- [Spec-Driven Development](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/) - Plan before code
- [Get Shit Done](https://github.com/glittercowboy/get-shit-done) - Context engineering
- [Agent OS](https://github.com/ajaygunalan/agent-os) - Standards as context
- [Anthropic Multi-Agent Research](https://www.anthropic.com/engineering/multi-agent-research-system) - Parallel investigation

---

## Future

| Feature | Status |
|---------|--------|
| `tasksDirectory` setting | [#20425](https://github.com/anthropics/claude-code/issues/20425) |


---

## License

MIT
