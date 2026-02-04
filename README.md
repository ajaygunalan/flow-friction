# Flow-Friction

> Flow fast. Friction for what survives.

---

## What & Why

A meta-prompting framework for solo research. Commands like `/research`, `/plan`, `/implement` add structure on top of Claude Code — context management, workflows, thinking tools.

Most frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done), [Agent OS](https://github.com/ajaygunalan/agent-os), [Spec-Driven](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/)) copy enterprise processes: project init, phase tracking, mandatory progression, audit trails. This works for teams shipping products. It fails for research.

Research is exploratory. Nine ideas die for every one that survives. You don't know what you're building until you've tried building it. Upfront ceremony wastes time on plans that get abandoned.

Flow-Friction inverts the order: explore first, structure survivors. No project init. No tracking files. No mandatory phases. When something survives and proves worth building, then add friction — a plan, refinement, proper implementation.

Built for solo researchers in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/research` | Investigate unknowns — debugging, feasibility, approaches |
| `/plan` | Create implementation plan with tasks |
| `/refine` | Audit plan coverage, patch gaps, log changes |
| `/implement` | Execute plan via subagents with atomic commits |
| `/verify` | Check implementation matches the plan |
| `/pause` | Save session state for later |
| `/resume` | Continue from saved state |
| `/map-codebase` | Generate architecture diagrams |
| `/commit_and_push` | Add checkpoint marker, push all commits |

### What You Know → Where to Start

```
"I know the fix"              →  Just ask Claude
"I know the cause"            →  Just ask Claude
"Something's wrong, not sure" →  /research
"I need to understand first"  →  /research
"I know what to build"        →  /plan
"I have a plan already"       →  /implement
```

### Dependencies

```
STANDALONE                     NEED A PLAN
──────────                     ───────────
/research ──┐                  /refine ────► refines existing plan
            │
/plan ──────┼───────────────►  /implement ─► executes plan tasks
            │
/map-codebase                  /verify ────► checks against plan

UTILITIES: /pause, /resume, /commit_and_push
```

---

## Flows

Mix and match based on what you know.

```
┌─────────────────────────────────────────────────────────────────────────┐
│  SIMPLE FIX (you know the fix)                                          │
│                                                                         │
│      Ask Claude ──────────────────────────────────────────────► Done    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  DEBUG (cause unknown)                                                  │
│                                                                         │
│      /research ───► find cause ───► fix ──────────────────────► Done    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  NEW FEATURE (you know what to build)                                   │
│                                                                         │
│      /plan ───► /implement ───► /verify ──────────────────────► Done    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  COMPLEX FEATURE (need to understand first)                             │
│                                                                         │
│      /research ───► /plan ───► /refine ◄──┐                             │
│                                    │      │ (iterate until solid)       │
│                                    └──────┘                             │
│                                    │                                    │
│                                    ▼                                    │
│                              /implement ───► /verify ─────────► Done    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## How It Works

### Stateless

No phase tracking. No mandatory sequence. Run any command anytime.

### Intent Preservation

Research is sculpting — intent evolves as you discover. Flow-Friction captures bookends, not the journey:

- `/research` outputs Original Intent and Evolved Understanding
- `/refine` appends a Refinement Log (what changed, why)
- `/pause` synthesizes session state for handoff

Synthesis at transitions. No continuous tracking.

### Parallel Research

`/research` assesses complexity: narrow topics get one scout agent, broad topics get 2-3 parallel scouts that synthesize findings. Based on [Anthropic's multi-agent research](https://www.anthropic.com/engineering/multi-agent-research-system).

### Coverage Audit

`/refine` compares plan against original request, marks requirements as Covered/Partial/Missing, patches gaps with minimal changes.

### Architecture Context

```
┌──────────────────────────────────────────────────────────────────┐
│                         SETUP (once)                             │
│                                                                  │
│   /map-codebase ───► diagrams/*.md ───► CLAUDE.md [[links]]      │
│                      (Mermaid)          (references diagrams)    │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                      EVERY SESSION                               │
│                                                                  │
│   Claude reads CLAUDE.md ───► Already knows architecture         │
│                               No discovery phase needed          │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                      DRIFT REDUCTION                             │
│                                                                  │
│   Code changes? ───► /map-codebase ───► Diagrams update          │
│                                         Docs = Code (no drift)   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

The diagrams ARE the documentation. Regenerate when code changes.

---

## Setup

### Minimal

Commands work immediately. Just use them.

### Recommended

Task Persistence — tasks survive `/clear` and new sessions:
```bash
# Add to ~/.bashrc or ~/.zshrc
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

Project-Local Plans:
```json
{ "plansDirectory": "docs/plan/" }
```

Single Plan Enforcement — auto-delete old plans, preserve research:
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

## Reference

### Research Methodologies

`/research` auto-selects methodology based on topic: `scout/technical`, `scout/open-source`, `scout/feasibility`, `scout/deep-dive`, `scout/competitive`, `scout/landscape`, `scout/history`, `scout/options`.

### Thinking Frameworks

Standalone reasoning tools, auto-selected or invoked directly: `think/inversion`, `think/first-principles`, `think/second-order`, `think/5-whys`, `think/pareto`, `think/opportunity-cost`, `think/swot`, `think/via-negativa`, `think/occams-razor`, `think/one-thing`, `think/10-10-10`, `think/eisenhower-matrix`, `think/crucible`.

### File Locations

| File | Purpose |
|------|---------|
| `docs/plan/RESEARCH.md` | Research findings with intent bookends |
| `docs/plan/*.md` | Plan files with refinement log |
| `diagrams/*.md` | Architecture diagrams |
| `RESUME.md` | Session handoff |
| `CLAUDE.md` | Project rules + diagram references |

### Commit Strategy

Two layers: atomic commits for AI traceability, checkpoint markers for human navigation.

```
/implement creates:
    ├── "Task 1: Add force sensor interface"
    ├── "Task 2: Implement PID controller"
    └── "Task 3: Add tests"

/commit_and_push adds:
    └── "[>>] Add force control" → Push all
```

Navigate history:
```bash
git log --oneline --grep="\[>>\]"  # Checkpoints (human)
git log --oneline                   # Full history (AI)
```

---

## License

[MIT](https://opensource.org/licenses/MIT)
