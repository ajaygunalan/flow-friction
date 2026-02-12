# Flow-Friction

> Flow fast. Friction for what survives.

A set of Claude Code skills for solo research workflows — context management, iteration, knowledge capture.

Most AI coding frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done)) are bloated with spec documents and rigid linear patterns. That fails for research — you don't know what you're building until you've tried building it. And whatever you do learn gets lost between sessions — Claude starts fresh every time, re-discovering what it already mapped yesterday.

Flow-Friction inverts the order: investigate first, structure survivors. Mermaid diagrams act as a living visual index — synced to the code, read every session via CLAUDE.md wiki-links. Claude opens each session already knowing the architecture. No re-discovery. No context-stuffing.

---

```
INVESTIGATE ──────────► PLAN ───────────────► BUILD ──────────────► DISTILL
/research                /plan (built-in)      /implement            /learn
/best-practices          /verify-plan          /commit_and_push      /index-sync
/conversation-search                                                 /next-prompt
```

### Investigate

Understand before acting. `/research` investigates unknowns — read code, run tests, trace bugs, write findings to `docs/research/`. Call it again and it continues where it left off (iteration 2, 3, ...). `/best-practices` names the problem class and checks your approach against expert-level patterns. `/conversation-search` finds what you've already learned across past sessions.

### Plan

Structure only what survived investigation. `/plan` (built-in Claude Code) drafts the implementation plan. `/verify-plan` asks you questions first, then audits every requirement and patches what's missing or partial.

### Build

One subagent per task. `/implement` delegates plan tasks to parallel subagents. `/commit_and_push` analyzes your changes, offers two commit message options (tighter vs. more detailed), commits with your choice, and pushes.

### Distill

Concentrate scattered knowledge into its one true home, delete the residue. `/learn` captures raw insights from the conversation into `docs/research/`. `/index-sync` distills them — absorbing findings into Mermaid diagrams, CLAUDE.md, code comments, README — then deletes the ephemeral source files. `/next-prompt` generates a ready-to-paste prompt for the next session.

This is where the Mermaid diagrams earn their keep. **The code is the book. Everything else is an index into it.** Mermaid diagrams are the visual index layer — they show how modules connect, how data flows, which functions transform what. Every session, Claude reads CLAUDE.md, follows wiki-links to `docs/diagrams/*.md`, and already knows the architecture. No re-discovery phase. No wasted context window. Every fact has exactly one home. Redundancy causes drift — when the same fact lives in 3 places, they eventually contradict each other. Research and plans are ephemeral; they get distilled and deleted. What survives lives in the code and its indexes.

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
