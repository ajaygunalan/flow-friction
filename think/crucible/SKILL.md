---
description: Multi-wave 6-framework deep analysis — parallel Codex CLI agents in 3 dependency waves
argument-hint: [subject to analyze] -- [source directory (optional, defaults to cwd)]
---

<objective>
Orchestrate a 3-wave, 6-agent deep analysis of $ARGUMENTS using Codex CLI (`codex exec`) agents.

Each agent is a separate `codex exec` process that reads its thinking methodology from the existing slash command file, reads source files from disk, applies the framework, and writes structured output.

Wave 1 (4 parallel): First Principles, Inversion, SWOT, Second-Order
Wave 2 (1 sequential): Via Negativa — informed by Wave 1 outputs
Wave 3 (1 sequential): Pareto Synthesis — synthesizes all prior outputs

```
Wave 1 (parallel):  [First Principles] [Inversion] [SWOT] [Second-Order]
                           \                |          |        /
Wave 2:                     +------→ [Via Negativa] ←------+
                                          |
Wave 3:                            [Pareto Synthesis]
```

WHY THIS ORDER:
- Wave 1 frameworks are orthogonal — zero cross-dependencies.
- Via Negativa (Wave 2) needs Wave 1 outputs to make informed cuts.
- Pareto (Wave 3) is the convergence function — needs everything.
</objective>

<process>

## Step 1: Parse Arguments

Split $ARGUMENTS on ` -- `:
- Left = SUBJECT (what to analyze)
- Right = SOURCE_DIR (absolute path; defaults to cwd if no separator)

If SUBJECT is empty, ask the user.

## Step 2: Discover Source Files

Glob for relevant files in SOURCE_DIR (*.md, *.txt, code files, etc.).
EXCLUDE `SOURCE_DIR/analysis/` — those are outputs.
Store absolute paths as SOURCE_FILES list.

Tell user: "Found N source files. Running crucible on: SUBJECT"

## Step 3: Create Directories

```bash
mkdir -p "${SOURCE_DIR}/analysis" /tmp/crucible
```

## Step 4: Write Agent Prompt Files

Write 6 prompt files to `/tmp/crucible/` using the Write tool.

Each prompt file has exactly three sections — HOW, WHAT, WHERE:

```
HOW TO ANALYZE:
Read this file for your thinking methodology:
{METHODOLOGY_FILE}

WHAT TO ANALYZE:
Subject: {SUBJECT}

Read these source files:
{SOURCE_FILES}

{Only for Wave 2-3 agents — omit entirely for Wave 1:}
Also read these prior analysis outputs:
{PRIOR_ANALYSIS_FILES}

{ADDITIONAL_INSTRUCTION}

WHERE TO WRITE:
Write your complete analysis to {OUTPUT_FILE}
Use markdown. Be rigorous, specific, reference concrete details. Do not hedge.
```

Agent table — substitute actual resolved paths when writing each file:

| # | Prompt file | Methodology file | Prior analyses | Output file | Additional instruction |
|---|---|---|---|---|---|
| 1 | /tmp/crucible/01-first-principles.txt | ~/.claude/skills/think/first-principles.md | (none) | ./analysis/01-first-principles.md | |
| 2 | /tmp/crucible/02-inversion.txt | ~/.claude/skills/think/inversion.md | (none) | ./analysis/02-inversion.md | |
| 3 | /tmp/crucible/03-swot.txt | ~/.claude/skills/think/swot.md | (none) | ./analysis/03-swot.md | |
| 4 | /tmp/crucible/04-second-order.txt | ~/.claude/skills/think/second-order.md | (none) | ./analysis/04-second-order.md | |
| 5 | /tmp/crucible/05-via-negativa.txt | ~/.claude/skills/think/via-negativa.md | analysis/01 through 04 | ./analysis/05-via-negativa.md | Use prior analyses to inform cuts — First Principles=fundamental, Inversion=failure prevention, SWOT=competitive relevance, Second-Order=hidden consequences. |
| 6 | /tmp/crucible/06-pareto-synthesis.txt | ~/.claude/skills/think/pareto.md | analysis/01 through 05 | ./analysis/06-pareto-synthesis.md | Final synthesis. Sections: THE CORE, THE CUT, THE RISKS, THE BLIND SPOTS, THE VERDICT, RECOMMENDED NEXT STEP. |

For "Prior analyses" column, use absolute paths: `{SOURCE_DIR}/analysis/01-first-principles.md`, etc.
Replace all {SUBJECT}, {SOURCE_FILES}, {SOURCE_DIR} placeholders with actual values.

## Step 5: Wave 1 — Launch 4 Parallel Codex Agents

Single Bash command (timeout 600000ms):

```bash
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/01-first-principles.txt &
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/02-inversion.txt &
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/03-swot.txt &
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/04-second-order.txt &
wait
echo "=== WAVE 1 COMPLETE ==="
```

If timeout risk, use run_in_background and poll for output files.

## Step 6: Verify Wave 1

Check all 4 exist and are non-empty:
- analysis/01-first-principles.md
- analysis/02-inversion.md
- analysis/03-swot.md
- analysis/04-second-order.md

Warn on failures. Ask user whether to proceed if any missing.

## Step 7: Wave 2 — Via Negativa

```bash
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/05-via-negativa.txt
echo "=== WAVE 2 COMPLETE ==="
```

## Step 8: Verify Wave 2

Check analysis/05-via-negativa.md exists.

## Step 9: Wave 3 — Pareto Synthesis

```bash
codex exec --full-auto -C "${SOURCE_DIR}" - < /tmp/crucible/06-pareto-synthesis.txt
echo "=== WAVE 3 COMPLETE ==="
```

## Step 10: Verify Wave 3

Check analysis/06-pareto-synthesis.md exists.

## Step 11: Present Results

Read 06-pareto-synthesis.md, extract THE VERDICT.
Report: completion status per file, the verdict, output file paths.

## Step 12: Cleanup

```bash
rm -rf /tmp/crucible
```

</process>

<success_criteria>
- All 6 analysis files created with substantive content
- Wave ordering strictly respected
- Each Codex agent reads its methodology from the actual think command file
- Via Negativa uses Wave 1 outputs
- Pareto synthesizes all 5 prior outputs
- User gets clear summary with verdict
</success_criteria>
