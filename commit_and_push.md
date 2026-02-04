---
disable-model-invocation: true
description: Add checkpoint marker and push all commits
allowed-tools:
  - Read
  - Edit
  - Bash
  - AskUserQuestion
---

<objective>
Push all atomic commits with a [>>] checkpoint marker for human navigation:
1. Analyze all changes since last push
2. Clear session log in CLAUDE.md
3. User selects checkpoint message
4. Create [>>] marker commit
5. Push all commits (atomic history preserved)
</objective>

<process>

## Phase 1: Gather context

Run these commands in parallel:
- `git status` (never use -uall flag)
- `git branch --show-current` (get current branch name)
- `git log origin/$(branch)..HEAD --oneline` (all unpushed commits)
- `git diff origin/$(branch)..HEAD --stat` (all unpushed changes summary)
- `git diff origin/$(branch)..HEAD` (all unpushed changes detail)

If there are no unpushed commits AND no uncommitted changes, inform the user there is nothing to push and stop.

## Phase 2: Summarize changes

Analyze ALL changes since last push (from Phase 1). This includes:
- All unpushed commits (will be pushed as-is)
- Any uncommitted changes (will be committed first)

Produce a concise summary of what changed since the last push.

## Phase 3: Clear session log

Clear the `## Session Log` section in CLAUDE.md: remove all entries but keep the heading:
```
## Session Log

```

If no session log section exists, skip this step.

## Phase 4: Generate checkpoint options + ask user

Generate exactly 4 checkpoint message options:
- Each is a single-line summary (imperative mood, ~50 chars)
- Options should represent different valid framings of the overall change
- This becomes the [>>] marker that humans use to navigate history

Use AskUserQuestion:
```
questions: [{
  question: "Which message captures this checkpoint?",
  header: "Checkpoint",
  options: [
    {label: "[Option 1]", description: "[brief context]"},
    {label: "[Option 2]", description: "[brief context]"},
    {label: "[Option 3]", description: "[brief context]"},
    {label: "[Option 4]", description: "[brief context]"}
  ],
  multiSelect: false
}]
```

## Phase 5: Commit and push

CRITICAL: The user's selected option becomes the EXACT checkpoint message. Do NOT modify, paraphrase, or "improve" it. Use their selection VERBATIM.

**Steps:**

1. Stage any uncommitted changes (prefer specific files over `git add -A`). Include CLAUDE.md if session log was cleared.

2. If there are uncommitted changes, commit them:
   ```bash
   git commit -m "$(cat <<'EOF'
   Final changes before checkpoint

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

3. Create the [>>] checkpoint marker commit:
   ```bash
   git commit --allow-empty -m "$(cat <<'EOF'
   [>>] [User's selected message - VERBATIM]

   Checkpoint marker for human navigation.

   Changes in this batch:
   - [bullet summary of what the atomic commits accomplished]

   To see atomic commits: git log --oneline [this-hash]^..[previous-checkpoint]
   To find checkpoints: git log --oneline --grep="\[>>\]"

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

4. Push to origin: `git push origin $branch`

5. Verify with `git status` and `git log --oneline -5`

</process>

<constraints>
- CHECKPOINT MESSAGE: User's selected option VERBATIM after [>>] - never modify it
- Never use `git add -A` or `git add .` - stage specific files
- Never skip hooks (no --no-verify)
- Never force push
- The [>>] commit is empty (--allow-empty) - it's just a marker
- Session log is cleared BEFORE committing so the cleared state is in the batch
</constraints>

<navigation>
After using this workflow, humans navigate history with:

```bash
# Find all checkpoints
git log --oneline --grep="\[>>\]"

# See what's between two checkpoints
git log checkpoint1..checkpoint2 --oneline

# Full history (AI traceability)
git log --oneline
```
</navigation>

<success_criteria>
- Session log is cleared
- All atomic commits preserved (AI traceability)
- [>>] marker commit created with user's message verbatim
- All commits pushed to remote
- Clean git status after completion
</success_criteria>
