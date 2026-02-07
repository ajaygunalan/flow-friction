---
description: Diagnose and fix a broken or misbehaving Claude Code skill. Use when a skill produces wrong output, fails to trigger, crashes mid-workflow, gives outdated instructions, or needs correction after execution revealed issues.
argument-hint: [optional: skill name or specific issue]
allowed-tools: Read, Edit, Glob, Grep, AskUserQuestion, Bash(ls:*)
---

## Available skills

!`ls -1 ~/.claude/skills/*/SKILL.md 2>/dev/null | sed 's|.*/skills/||;s|/SKILL.md||'`

---

## Process

### 1. Detect which skill

If `$ARGUMENTS` names a skill, use it. Otherwise:
- Check conversation context for recent skill invocations
- Look for SKILL.md references in recent messages
- If still unclear, ask the user

Set target: `~/.claude/skills/[name]/`

### 2. Read the skill

Read the full SKILL.md and any files in `references/`, `scripts/`, `assets/`.

### 3. Diagnose

Analyze the conversation to determine what went wrong. Classify:

- **Trigger failure** — description missing key trigger words, so skill never activates
- **Wrong instructions** — body tells Claude to do the wrong thing
- **Outdated content** — API endpoints, tool names, or patterns have changed
- **Missing context** — skill assumes knowledge Claude doesn't have
- **Structural issue** — frontmatter errors, body too long, resources not referenced
- **Tool restriction** — `allowed-tools` blocks a needed tool

For each issue found, note:
- What's wrong (quote the exact text)
- Why it's wrong (evidence from conversation or testing)
- What the fix is

### 4. Present proposed changes

```
Skill being healed: [name]
Issue: [1-2 sentence summary]
Root cause: [category from above]

Changes:

### [File] — [section]
Current:
> [exact text]

Fixed:
> [new text]

Reason: [why this fixes it]
```

Repeat for each change across all files.

**Wait for user approval. Do not edit without it.**

### 5. Apply fixes

After approval:
1. Apply each edit
2. Read back modified sections to confirm changes took
3. Check cross-file consistency (body references match actual resource files)

### 6. Report

```
Healed: [skill name]
Files modified: [list]
Changes: [count]
Test by: [how to verify the fix works]
```
