# Flow-Friction

> Flow fast. Friction for what survives.

---

## What & Why

A meta-prompting framework for solo research. Commands like `/research`, `/implement`, `/index-sync` add structure on top of Claude Code — context management, workflows, thinking tools.

Most frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done), [Agent OS](https://github.com/ajaygunalan/agent-os), [Spec-Driven](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/) and [github](https://github.com/alexanderop/dotfiles)) copy enterprise processes: project init, phase tracking, mandatory progression, audit trails. This works for teams shipping products. It fails for research.

Research is exploratory. Nine ideas die for every one that survives. You don't know what you're building until you've tried building it. Upfront ceremony wastes time on plans that get abandoned.

Flow-Friction inverts the order: explore first, structure survivors. No project init. No tracking files. No mandatory phases. When something survives and proves worth building, then add friction — a plan, refinement, proper implementation.

Built for solo researchers in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Documentation Philosophy

**The book is the code. Everything else is an index into the book.**

Knowledge is layered through progressive disclosure. A reader starts at the top and drills only as deep as they need:

```
README             →  "what is this" (human entry point)
CLAUDE.md          →  "where to look" (agent entry point, read every session)
  ↓
Mermaid diagrams   →  "how it connects" (visual indexes)
  ↓
Reference docs     →  "cross-file detail" (rare — only when no single file owns it)
  ↓
Code comments      →  "what will bite you here" (margin notes, last resort)
  ↓
Code               →  the book (source of truth)
```

**Every fact has exactly one home.** Redundancy causes drift — when the same fact lives in 3 places, they eventually contradict each other. No redundancy across levels. Lower levels link to higher levels (`# See docs/diagrams/wrench_pipeline.md`), never re-explain.

**Comments only prevent misunderstanding.** The moment you comment everything, comments become noise and the real traps disappear. Comment only when someone will misunderstand without it — a trap, a non-obvious constraint, a design choice that looks wrong but isn't. Not every file. Not every function. Not every class. Just where it prevents harm.

Research and plans are ephemeral — they live in `docs/research/` and `docs/plan/`, get absorbed into their permanent home in the hierarchy, then deleted. `/index-sync` does this absorption and keeps all indexes in sync with the code.

---

## Commands

### Build

| Command | What It Does |
|---------|--------------|
| `/research` | Investigate unknowns — read code, run tests, trace bugs, write findings to `docs/research/` |
| `/plan` | Create implementation plan (built-in Claude Code feature, not a Flow-Friction skill) |
| `/verify-plan` | Ask user questions, then audit and patch the plan |
| `/implement` | Execute plan via subagent delegation |

### Learn

| Command | What It Does |
|---------|--------------|
| `/learn` | Capture insights from the conversation into `docs/research/` (ephemeral — placed by `/index-sync`) |
| `/conversation-search` | Search past conversation history |
| `/index-sync` | Sync all knowledge indexes to match current code — README, CLAUDE.md, diagrams, reference docs, code comments |

### Review

| Command | What It Does |
|---------|--------------|
| `/review` | Code review with configurable thoroughness |
| `/best-practices` | Analyze current problem against expert-level best practices |

### Utilities

| Command | What It Does |
|---------|--------------|
| `/commit_and_push` | Commit and push with user-chosen message |
| `/next-prompt` | Generate a ready-to-paste prompt for the next session or agent |

### What You Know → Where to Start

```
"I know the fix"              →  Just ask Claude
"I know the cause"            →  Just ask Claude
"Something's wrong, not sure" →  /research
"I need to understand first"  →  /research
"I know what to build"        →  /plan (built-in Claude Code)
"I have a plan already"       →  /verify-plan → /implement
"Indexes drifted"             →  /index-sync
"What did we learn recently?" →  /conversation-search + /learn
```

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
│      /plan ───► /verify-plan ───► /implement ────────────────► Done    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  COMPLEX FEATURE (need to understand first)                             │
│                                                                         │
│      /research ───► /plan ───► /verify-plan ◄──┐                        │
│                                    │           │ (iterate until solid)  │
│                                    └───────────┘                        │
│                                    │                                    │
│                                    ▼                                    │
│                              /implement ──────────────────────► Done    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│  INDEX SYNC (code changed, indexes drifted)                             │
│                                                                         │
│      /index-sync ───► analyze all indexes against code                  │
│                        │                                                │
│                        ▼                                                │
│                   executive summary ───► user picks what to fix         │
│                        │                                                │
│                        ▼                                                │
│                   update diagrams, docs, comments, CLAUDE.md, README   │
│                   drain ephemeral files, delete absorbed sources        │
│                        │                                                │
│                        ▼                                                │
│                      Done (all indexes match the code)                  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## How It Works

### Stateless

Other frameworks track "current phase" in state files — you must be in "planning" before "implementing." Flow-Friction has no state. Run any command anytime. Skip what you don't need.

### Research Iteration

Each `/research` call is one iteration — investigate, write findings to `docs/research/<topic>.md`. The file carries state between sessions. Call `/research` again, it finds the active file and continues (iteration 2, 3, ...). When done, `/index-sync` absorbs findings into their permanent home in the hierarchy and deletes the research file. Use `/next-prompt` to hand off to a new session.

### Coverage Audit

`/verify-plan` asks the user for questions about the plan first, then checks each requirement and patches what's missing or partial.

### Index Sync

```
┌──────────────────────────────────────────────────────────────────┐
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
│   Code changed? ───► /index-sync ───► All indexes updated        │
│                                       (diagrams, docs, comments, │
│                                        CLAUDE.md, README)        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

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

### File Locations

| File | Purpose |
|------|---------|
| `docs/research/*.md` | Per-topic research files (ephemeral — absorbed by `/index-sync`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Mermaid architecture diagrams (permanent index) |
| `CLAUDE.md` | Agent routing table — commands, debug-by-symptom, diagram links |
| `README` | Human entry point — project overview |

### Commit Strategy

`/commit_and_push` analyzes changes, offers 2 commit message options (tighter vs. more detailed, with subject+body format), commits with your choice, and pushes.

---

## License

[MIT](https://opensource.org/licenses/MIT)
