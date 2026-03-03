---
name: review-fix
description: Request a code review and fix findings. Use when the user says "review", "review-fix", or wants to check code quality.
argument-hint: [commit] [--branch] [--base <branch>] [--type security|design] [--fix [job_id...]]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# /review-fix

Review code and fix findings. Two modes: review (default) and fix.

## Review mode

```
/review-fix [commit] [--branch] [--base <branch>] [--type security|design]
```

### 1. Validate inputs

If a commit ref is provided, verify it resolves:

```bash
git rev-parse --verify -- <commit>^{commit}
```

If invalid, inform the user. Do not proceed.

### 2. Run the review in the background

```bash
roborev review [commit] --wait [--branch] [--base <branch>] [--type <type>]
```

- No commit → defaults to HEAD
- `--branch` → reviews all commits on the current branch
- `--base` → sets the base branch for `--branch` comparison
- `--type` → security or design review

Tell the user the review is submitted. Present results when complete.

### 3. Present results

If error (daemon not running, repo not initialized, review errored) → report it. Suggest `roborev status` or `roborev init`.

Otherwise:
- Show verdict prominently (Pass or Fail)
- If findings, list them grouped by severity with file paths and line numbers
- If passed, brief confirmation is sufficient

### 4. Offer to fix

If verdict is Fail, offer: "Would you like me to fix these findings?"

Extract the job ID from the review output to include in the suggestion.

## Fix mode

```
/review-fix --fix [job_id...]
```

### 1. Discover reviews

If job IDs are provided, use those. Otherwise discover unaddressed reviews:

```bash
roborev fix --unaddressed --list
```

If none found, inform the user.

### 2. Fetch reviews

For each job ID:

```bash
roborev show --job <job_id> --json
```

JSON structure:
- `job_id`: the job ID
- `output`: review text with findings
- `job.verdict`: `"P"` for pass, `"F"` for fail
- `job.git_ref`: the reviewed git ref
- `addressed`: whether already addressed

Skip passing reviews, empty verdicts, and already-addressed reviews (unless explicitly requested by user).

### 3. Fix findings

Use `job.git_ref` to understand scope. If not `"dirty"`, run `git show <git_ref>` to see the original diff.

Parse findings from all failing reviews, then:
1. Group by file to minimize context switches
2. Fix by priority (high severity first)
3. Same file with findings from multiple reviews → fix together
4. Cannot fix (false positives, intentional) → note for the comment

### 4. Run tests

Run the project's test suite. If tests fail, fix regressions before proceeding.

### 5. Record and mark addressed

For each job addressed:

```bash
roborev comment --job <job_id> "<summary>" && roborev address <job_id>
```

Summary: what changed and why, referencing files and findings. Under 2-3 sentences per review.
