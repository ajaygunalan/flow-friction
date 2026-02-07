---
description: Create a new Claude Code skill with proper structure and best practices. Use when asked to "create a skill", "new skill", "build a skill", "make a skill for", or when a user describes a repeatable workflow they want to automate.
argument-hint: [skill name and/or what it should do]
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash(mkdir:*), Bash(ls:*)
---

## Existing skills

!`ls -1 ~/.claude/skills/*/SKILL.md 2>/dev/null | sed 's|.*/skills/||;s|/SKILL.md||'`

---

## Process

### 1. Gather requirements

If `$ARGUMENTS` is vague or missing, ask the user:
- What should the skill do? (one capability only)
- What trigger phrases should invoke it? ("when I say X")
- Give an example of using it

If `$ARGUMENTS` is clear, skip to step 2.

### 2. Plan the skill

Determine:
- **Skill name**: lowercase kebab-case, max 40 chars
- **Description**: what it does + when to trigger (this is the ONLY thing Claude reads to decide when to use it — be specific with trigger words)
- **Body**: the instructions. Keep under 100 lines. Only include what Claude doesn't already know.
- **Resources needed?**
  - `references/` — domain docs Claude should read on-demand (keeps body lean)
  - `scripts/` — deterministic code for repeated operations
  - `assets/` — templates/files used in output
  - Most skills need none of these. Only add if clearly justified.

Present the plan:

```
Skill: [name]
Location: ~/.claude/skills/[name]/SKILL.md
Description: [full description]
Body outline: [section list]
Resources: [none / list with rationale]
```

**Wait for approval before writing anything.**

### 3. Write the skill

After approval:

1. Create directory: `~/.claude/skills/[name]/`
2. Write `SKILL.md` with:
   - Frontmatter: `description` (required), `argument-hint` (if takes args), `allowed-tools` (if restricting tools)
   - Body: concise markdown instructions — imperative voice, no fluff
3. Create resource directories and files only if planned
4. Read back the written SKILL.md to confirm correctness

### 4. Verify

- Frontmatter has `description` with trigger words
- Body is under 100 lines
- No duplicate of an existing skill (check list above)
- No README, CHANGELOG, or auxiliary docs created
- Resource files referenced from body if they exist

Report: skill created at `~/.claude/skills/[name]/SKILL.md`, trigger phrases, and how to test it.
