---
name: break-into-bricks
description: Break sharp research questions into smallest testable bricks — each with pass/fail, failure modes, observability
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Break Into Bricks: $ARGUMENTS

## Prerequisite

`docs/research/what-to-build.md` must exist with sharp Q1/Q2 structure.

If it's missing, tell the user: "I need `docs/research/what-to-build.md`. Run `/brain-dump <your topic>` first." Then stop.

If it exists but looks rough (no numbered questions), tell the user: "what-to-build.md needs sharpening first. Run `/sharpen-it`." Then stop.

## What this produces

`docs/research/how-to-test.md` — smallest testable bricks.

## Steps

1. Read `docs/research/what-to-build.md`
2. Spawn 2-3 subagents in parallel:
   - **Explore:** map existing test/verification patterns in the codebase
   - **HITL:** where can human-in-the-loop substitute for unsolved research problems?
   - (if complex) **Tools:** what libraries/frameworks are available for testing?
3. Synthesize into smallest testable bricks — each with:
   - What it proves
   - Pass/fail criteria (binary where possible)
   - Failure modes (what to look for when it breaks)
   - What gets logged (for human + AI diagnosis)
   - Dependencies on other bricks
4. Write `docs/research/how-to-test.md`
5. AskUserQuestion: revise or continue?

## Next

"Next: `/stack-bricks` to decide build order."
