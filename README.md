# Flow-Friction

> Flow fast. Friction for what survives.

A set of Claude Code skills for solo research workflows — context management, iteration, knowledge capture.

---

## The Problem

Most AI coding frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done), [Spec-Driven](https://alexop.dev/posts/spec-driven-development-claude-code-in-action/)) copy enterprise ceremony: project init, phase tracking, mandatory progression. That works for teams shipping products. It fails for research — you don't know what you're building until you've tried building it. Flow-Friction inverts the order: explore first, structure survivors.

---

## The Rhythm

```
EXPLORE ──────────────► DECIDE ─────────────► BUILD ──────────────► REMEMBER
/research                /plan (built-in)      /implement            /learn
/best-practices          /verify-plan          /commit_and_push      /index-sync
/conversation-search                                                 /next-prompt
```

### Explore

Understand before acting. `/research` investigates unknowns — read code, run tests, trace bugs, write findings to `docs/research/`. Call it again and it continues where it left off (iteration 2, 3, ...). `/best-practices` names the problem class and checks your approach against expert-level patterns. `/conversation-search` finds what you've already learned across past sessions.

### Decide

Structure only what survived exploration. `/plan` (built-in Claude Code) drafts the implementation plan. `/verify-plan` asks you questions first, then audits every requirement and patches what's missing or partial.

### Build

One subagent per task. `/implement` delegates plan tasks to parallel subagents. `/commit_and_push` analyzes your changes, offers two commit message options (tighter vs. more detailed), commits with your choice, and pushes.

### Remember

Capture what matters, discard the scaffolding. `/learn` extracts insights from the conversation into `docs/research/`. `/index-sync` absorbs those findings into their permanent home — diagrams, docs, comments, CLAUDE.md, README — then deletes the ephemeral source files. `/next-prompt` generates a ready-to-paste prompt for the next session.

The underlying idea: **the code is the book, everything else is an index into it.** Every fact has exactly one home. Redundancy causes drift — when the same fact lives in 3 places, they eventually contradict each other. Research and plans are ephemeral; they get absorbed and deleted. What survives lives in the code and its indexes.

---

## What You Know → Where to Start

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

---

## Flows

Mix and match based on what you know.

```
┌───────────────────────────────────────────────────────────────────┐
│  SIMPLE FIX (you know the fix)                                    │
│                                                                   │
│    Ask Claude ────────────────────────────────────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  DEBUG (cause unknown)                                            │
│                                                                   │
│    /research ───► find cause ───► fix ───────────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  NEW FEATURE (you know what to build)                             │
│                                                                   │
│    /plan ───► /verify-plan ───► /implement ──────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  COMPLEX FEATURE (need to understand first)                       │
│                                                                   │
│    /research ───► /plan ───► /verify-plan ◄──┐                    │
│                                  │           │ (iterate)          │
│                                  └───────────┘                    │
│                                  │                                │
│                                  ▼                                │
│                            /implement ───────────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  INDEX SYNC (code changed, indexes drifted)                       │
│                                                                   │
│    /index-sync ───► analyze all indexes against code              │
│                      │                                            │
│                      ▼                                            │
│                 executive summary ───► user picks what to fix     │
│                      │                                            │
│                      ▼                                            │
│                 update diagrams, docs, comments, CLAUDE.md,       │
│                 README — drain ephemeral files, delete absorbed   │
│                      │                                            │
│                      ▼                                            │
│                    Done (all indexes match the code)              │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## How It's Different

**Stateless.** No tracking files, no "current phase." Run any command anytime. Skip what you don't need. Other frameworks require you to be in "planning" before "implementing" — Flow-Friction doesn't.

**No ceremony.** No project init, no mandatory progression. Research files are ephemeral — they get absorbed into their permanent home and deleted. The only persistent artifacts are the code and its indexes.

**Built for solo researchers** in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Quick Start

Commands work immediately. Just use them.

**Recommended settings** — `~/.claude/settings.json`:

```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "alwaysThinkingEnabled": true,
  "plansDirectory": "docs/plan/"
}
```

| Setting | Why |
|---------|-----|
| `ENABLE_TOOL_SEARCH` | Deferred tool loading — lets `/research` discover MCP tools on the fly |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Multi-agent coordination — used by `/research` and `/implement` |
| `bypassPermissions` | Skip confirmation prompts (solo use only — don't enable on shared machines) |
| `alwaysThinkingEnabled` | Always-on extended thinking |
| `plansDirectory` | Store plans in `docs/plan/` instead of `~/.claude/plans/` |

**Task persistence** — tasks survive `/clear` and new sessions:

```bash
# Add to ~/.bashrc or ~/.zshrc
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

<details>
<summary><b>Advanced setup</b></summary>

**Single Plan Enforcement** — auto-delete old plans when a new one is written:

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

</details>

---

## File Layout

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Per-topic research files (ephemeral — absorbed by `/index-sync`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Mermaid architecture diagrams (permanent index) |
| `CLAUDE.md` | Agent routing table — commands, debug-by-symptom, diagram links |
| `README` | Human entry point — project overview |

---

## Commands

| Command | Description |
|---------|-------------|
| `/research` | Investigate unknowns — read code, run tests, trace bugs, write findings to `docs/research/` |
| `/best-practices` | Analyze current problem against expert-level best practices |
| `/conversation-search` | Search past conversation history |
| `/plan` | Create implementation plan (built-in Claude Code, not a Flow-Friction skill) |
| `/verify-plan` | Ask user questions, then audit and patch the plan |
| `/implement` | Execute plan via subagent delegation |
| `/commit_and_push` | Commit and push with user-chosen message |
| `/review` | Code review with configurable thoroughness |
| `/learn` | Capture conversation insights into `docs/research/` |
| `/index-sync` | Sync all knowledge indexes to match current code |
| `/next-prompt` | Generate a ready-to-paste prompt for the next session or agent |

---

## License

[MIT](https://opensource.org/licenses/MIT)
