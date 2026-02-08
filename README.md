# Flow-Friction

> Flow fast. Friction for what survives.

---

## What & Why

A meta-prompting framework for solo research. Commands like `/research`, `/implement`, `/clean-docs` add structure on top of Claude Code — context management, workflows, thinking tools.

Most frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done), [Agent OS](https://github.com/ajaygunalan/agent-os), [Spec-Driven](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/) and [github](https://github.com/alexanderop/dotfiles)) copy enterprise processes: project init, phase tracking, mandatory progression, audit trails. This works for teams shipping products. It fails for research.

Research is exploratory. Nine ideas die for every one that survives. You don't know what you're building until you've tried building it. Upfront ceremony wastes time on plans that get abandoned.

Flow-Friction inverts the order: explore first, structure survivors. No project init. No tracking files. No mandatory phases. When something survives and proves worth building, then add friction — a plan, refinement, proper implementation.

Research lives in `docs/research/<topic>.md` — per-topic files with YAML frontmatter (`status: iteration N` while ongoing, `status: complete` when done). The spec is permanent — it's the source of truth. `/clean-docs` absorbs completed research into the spec and deletes the source files.

Built for solo researchers in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Commands

### Build

| Command | What It Does |
|---------|--------------|
| `/research` | Investigate unknowns — new features, debugging, refactoring, feasibility, exploration |
| `/plan` | Create implementation plan (built-in Claude Code feature, not a Flow-Friction skill) |
| `/verify-plan` | Audit plan coverage, ask about gaps, patch |
| `/implement` | Execute plan via subagent delegation |
### Learn

| Command | What It Does |
|---------|--------------|
| `/learn` | Capture insights from the current conversation |
| `/conversation-search` | Search past conversation history |
| `/clean-docs` | Read all docs, fix contradictions and redundancy, keep the spec clean |

### Review

| Command | What It Does |
|---------|--------------|
| `/review` | Code review with configurable thoroughness |
| `/best-practices` | Analyze current problem against expert-level best practices |

### Utilities

| Command | What It Does |
|---------|--------------|
| `/pause` | Update active research file (if any) + save session state |
| `/resume` | Continue from saved state |
| `/map-codebase` | Generate Mermaid architecture diagrams |
| `/commit_and_push` | Commit and push with user-chosen message |
| `/create-skill` | Create a new skill |
| `/heal-skill` | Fix a broken skill |

### What You Know → Where to Start

```
"I know the fix"              →  Just ask Claude
"I know the cause"            →  Just ask Claude
"Something's wrong, not sure" →  /research
"I need to understand first"  →  /research
"I know what to build"        →  /plan (built-in Claude Code)
"I have a plan already"       →  /verify-plan → /implement
"Docs are messy"              →  /clean-docs
"What did we learn recently?" →  /conversation-search + /learn
```

### Dependencies

```
STANDALONE                     NEED A PLAN
──────────                     ───────────
/research ──┐                  /verify-plan ► audits + patches existing plan
            │
/plan ──────┼───────────────►  /verify-plan ► verifies plan  (built-in Claude Code)
            │                  /implement ─► executes plan tasks
            │
/map-codebase

LEARNING: /learn ───► /clean-docs (absorbs into spec)
SEARCH:   /conversation-search

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
│      /plan ───► /implement ──────────────────────────────────► Done    │
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
│  DOC CLEANUP (knowledge accumulated, docs drifted)                      │
│                                                                         │
│      /learn ───► docs/ ──────────────────────┐                          │
│      /research ───► docs/research/*.md ───────┤                          │
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

### Research Iteration

Each `/research` call is one iteration — agents investigate, findings are written to `docs/research/<topic>.md`. The file carries state between sessions. Two paths to iterate:

- **`/research` only**: call it again, it finds the active file and continues (iteration 2, 3, ...)
- **`/pause` + `/resume`**: pause captures conversational discoveries into the research file + RESUME.md; resume loads context, then `/research` continues

`/research` proposes a dynamic team via AskUserQuestion — number and roles of agents are tailored to the problem (not from a fixed menu). See [Anthropic's multi-agent research](https://www.anthropic.com/engineering/multi-agent-research-system) for the underlying approach.

### Coverage Audit

`/verify-plan` compares plan against original request, marks requirements as Covered/Partial/Missing, asks clarifying questions about gaps, patches with minimal changes.

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

### File Locations

| File | Purpose |
|------|---------|
| `docs/research/*.md` | Per-topic research files with YAML frontmatter (absorbed by `/clean-docs` when `status: complete`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Architecture diagrams |
| `docs/RESUME.md` | Session handoff |
| `CLAUDE.md` | Project rules + diagram references |

### Commit Strategy

`/commit_and_push` analyzes changes, offers 4 commit message options, commits with your choice, and pushes.

---

## License

[MIT](https://opensource.org/licenses/MIT)
