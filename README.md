# Flow-Friction

> Flow fast. Friction for what survives.

---

## What & Why

A meta-prompting framework for solo research. Commands like `/research`, `/plan`, `/implement` add structure on top of Claude Code — context management, workflows, thinking tools.

Most frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done), [Agent OS](https://github.com/ajaygunalan/agent-os), [Spec-Driven](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/) and [github](https://github.com/alexanderop/dotfiles)) copy enterprise processes: project init, phase tracking, mandatory progression, audit trails. This works for teams shipping products. It fails for research.

Research is exploratory. Nine ideas die for every one that survives. You don't know what you're building until you've tried building it. Upfront ceremony wastes time on plans that get abandoned.

Flow-Friction inverts the order: explore first, structure survivors. No project init. No tracking files. No mandatory phases. When something survives and proves worth building, then add friction — a plan, refinement, proper implementation.

Some docs are temporary (`RESEARCH.md`, `INSIGHTS.md`) — they capture what you're learning right now. The spec is permanent — it's the source of truth. `/clean-docs` absorbs the temporary into the permanent and deletes the rest.

Built for solo researchers in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Commands

### Build

| Command | What It Does |
|---------|--------------|
| `/research` | Investigate unknowns — debugging, feasibility, approaches |
| `/plan` | Create implementation plan with tasks |
| `/refine` | Audit plan coverage, patch gaps |
| `/implement` | Execute plan via subagents with atomic commits |
| `/verify` | Check implementation matches the plan |

### Learn

| Command | What It Does |
|---------|--------------|
| `/learn` | Capture insights from the current conversation |
| `/insights-from-2-days` | Surface insights from recent conversations (today + yesterday) |
| `/clean-docs` | Read all docs, fix contradictions and redundancy, keep the spec clean |

### Review

| Command | What It Does |
|---------|--------------|
| `/review` | Code review with configurable thoroughness |
| `/best-practices` | Expert-level best practices analysis |

### Utilities

| Command | What It Does |
|---------|--------------|
| `/pause` | Save session state for later |
| `/resume` | Continue from saved state |
| `/map-codebase` | Generate architecture diagrams |
| `/commit_and_push` | Add checkpoint marker, push all commits |
| `/conversation-search` | Search past conversation history |
| `/create-skill` | Create a new skill |
| `/heal-skill` | Fix a broken skill |
| `/codex` | Pass a prompt to Codex CLI |

### What You Know → Where to Start

```
"I know the fix"              →  Just ask Claude
"I know the cause"            →  Just ask Claude
"Something's wrong, not sure" →  /research
"I need to understand first"  →  /research
"I know what to build"        →  /plan
"I have a plan already"       →  /implement
"Docs are messy"              →  /clean-docs
"What did we learn recently?" →  /insights-from-2-days
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

LEARNING: /learn, /insights-from-2-days ───► /clean-docs (absorbs into spec)

UTILITIES: /pause, /resume, /commit_and_push, /conversation-search
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
├─────────────────────────────────────────────────────────────────────────┤
│  DOC CLEANUP (knowledge accumulated, docs drifted)                      │
│                                                                         │
│      /insights-from-2-days ───► INSIGHTS.md ──┐                         │
│      /learn ───► docs/ ──────────────────────┐│                         │
│      /research ───► RESEARCH.md ─────────────┼┘                         │
│                                              ▼                          │
│                                        /clean-docs ──────────► Done     │
│                              (absorbs temporary docs into spec,         │
│                               deletes the ephemeral files)              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## How It Works

### Stateless

Other frameworks track "current phase" in state files — you must be in "planning" before "implementing." Flow-Friction has no state. Run any command anytime. Skip what you don't need.

### Intent Preservation

You start with one idea, research reveals something better, your understanding evolves. This usually happens in conversation and gets lost.

Flow-Friction captures two points: where you started (Original Intent) and where you ended up (Evolved Understanding). Not every step — just the endpoints.

- `/research` records Original Intent → Evolved Understanding
- `/refine` logs what changed in the plan and why
- `/pause` synthesizes current state for the next session

### Parallel Research

`/research` assesses complexity: narrow topics get one scout agent, broad topics get 2-3 parallel scouts that synthesize findings. See [Anthropic's multi-agent research](https://www.anthropic.com/engineering/multi-agent-research-system) for the underlying approach.

### Coverage Audit

`/refine` compares plan against original request, marks requirements as Covered/Partial/Missing, patches gaps with minimal changes.

### Architecture Context

```
┌──────────────────────────────────────────────────────────────────┐
│                         SETUP (once)                             │
│                                                                  │
│   /map-codebase ───► docs/diagrams/*.md ───► CLAUDE.md [[links]] │
│                      (Mermaid)               (references diagrams)│
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                      EVERY SESSION                               │
│                                                                  │
│   Claude starts ───► reads CLAUDE.md ───► follows [[wiki-links]] │
│                                                  │               │
│                                                  ▼               │
│                                        docs/diagrams/*.md        │
│                                                  │               │
│                                                  ▼               │
│                                     Already knows architecture   │
│                                     No discovery phase needed    │
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

Single Plan Enforcement — auto-delete old plans when a new one is written:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "FILE=$(jq -r '.tool_input.file_path'); DIR=$(dirname \"$FILE\"); echo \"$FILE\" | grep -q 'docs/plan/' && [ ! -f \"$FILE\" ] && find \"$DIR\" -maxdepth 1 -name '*.md' -delete || true"
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
| `docs/RESEARCH.md` | Research findings (ephemeral — absorbed by `/clean-docs`) |
| `docs/INSIGHTS.md` | Recent conversation insights (ephemeral — absorbed by `/clean-docs`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Architecture diagrams |
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
