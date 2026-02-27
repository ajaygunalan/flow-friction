---
name: skill-analyzer
description: Extract the minimal generative principles underlying a skill through multi-agent adversarial debate.
argument-hint: <path to SKILL.md>
---

# Skill Analyzer: $ARGUMENTS

$ARGUMENTS must be a path to a SKILL.md file. If not provided, ask.

## What this produces

A single file `skill-analysis/{skill-name}-principles.md` containing:
1. The minimal set of generative principles (typically 3-7)
2. A derivation proof mapping every tactical rule to its principle(s)
3. A reduction proof showing no principle can be dropped

## Setup

1. Read the target SKILL.md.
2. Create `skill-analysis/` directory (if missing) and a working subdirectory `skill-analysis/.analysis/` for intermediate files.
3. **Enumerate every tactical rule** in the SKILL.md as a numbered list (R1, R2, ... Rn). Write to `skill-analysis/.analysis/rules.md`. This is the shared reference — all agents work from this list.
4. Create team: `skill-analysis-{skill-name}`.
5. Create three tasks (Phase 1, Phase 2, Phase 3) with Phase 2 blocked by Phase 1, Phase 3 blocked by Phase 2.

## The three agents

Spawn all three in parallel as **`general-purpose`** agents (they must have Write access) with `run_in_background: true`. Include the full SKILL.md content and the enumerated rules list in each agent's spawn prompt — don't make them read files to get started.

| Agent | Name | Lens |
|-------|------|------|
| 1 | `reductionist` | Minimize count. Aggressively merge. Test: "is this a principle or a tactic dressed up?" Aim for 3-5. |
| 2 | `structuralist` | Find structural tensions/dimensions. What axes does the skill manage? What patterns repeat? |
| 3 | `phenomenologist` | Reverse-engineer from user experience. What does using this feel like? What beliefs about cognition does it encode? |

## Phase 1 — Independent extraction

Each agent writes their extraction to `skill-analysis/.analysis/{agent-name}.md`.

Required format:
```
# {Agent} Extraction

## Principles (numbered)
1. **Name** — Statement.
   - Rules it generates: [R1, R5, R12, ...]

## Reasoning
Why this set. What was merged/excluded and why.
```

Agents work independently — no cross-reading. Wait for all three to complete before Phase 2.

## Phase 2 — Cross-critique

Send each agent a message telling them to read the other two extraction files and write their critique to `skill-analysis/.analysis/{agent-name}-critique.md`. The message should list the file paths to read.

Critique format:
1. **Redundancies** — which principles overlap? Can they merge?
2. **False principles** — any that fail the generativity test? (Must generate multiple rules.)
3. **Missing principles** — did others surface something your set can't generate?
4. **Revised set** — updated principles given what you've seen.

Each agent sends a short summary message (3-5 sentences) when done — the detail lives in the file.

Wait for all three. Read the critique files. Summarize consensus and contested items for Phase 3.

## Phase 3 — Synthesis + adversarial verification

Send the reductionist a message with the consensus/contested summary. They write the synthesis to `skill-analysis/.analysis/synthesis.md`:
1. Final principle set incorporating consensus
2. Explicit ruling on each contested item (include/exclude/absorb + why)
3. Full derivation proof table: every Rn → principle(s)
4. Flag any orphan rules

Then send structuralist and phenomenologist a message to read the synthesis and adversarially verify:
- **Derivation test**: pick 5 rules, derive each from principles alone — forced or loose?
- **Sufficiency test**: would these principles alone produce a similar skill?
- **Contested items**: accept or counter-argue?
- **Verdict**: accept, accept-with-modifications, or reject

Each writes verdict to `skill-analysis/.analysis/{agent-name}-verdict.md` and sends short summary message.

## Finalization

1. Read the synthesis and both verdicts.
2. Incorporate accepted modifications.
3. Write the final document to `skill-analysis/{skill-name}-principles.md` containing:
   - Each principle: name, statement, derived rules
   - Derivation proof table (every rule → principle)
   - Reduction proof (removing any principle orphans rules)
   - Excluded items with reasoning
4. Clean up: shut down all agents, delete team, delete `skill-analysis/.analysis/`.

## Key constraints

- **Agents MUST be `general-purpose`** — `rubber-duck` and other read-only agents cannot write files, which breaks the entire workflow.
- **All Phase 1 agents launch in parallel** with `run_in_background: true`.
- **Include source material in spawn prompts** — paste the SKILL.md content and rules list directly into the agent prompt so they start working immediately without file reads.
- **Agents write files, send short messages** — detail in files, summaries in messages. Keeps message traffic manageable.
- **Generativity test**: a principle must generate multiple rules. One rule = tactic, not principle.
- **The derivation proof is the core deliverable** — no rule left unmapped, no principle left unused.
