---
name: reflect
description: Analyze diary entries to identify patterns and propose CLAUDE.md updates
---

# Reflect on Diary Entries and Synthesize Insights

You are going to analyze multiple diary entries to identify recurring patterns, synthesize insights, and propose updates to the user's CLAUDE.md file.

## Parameters

The user can provide:
- **Date range**: "from YYYY-MM-DD to YYYY-MM-DD" or "last N days"
- **Entry count**: "last N entries" (e.g., "last 10 entries")
- **Pattern filter**: "related to [keyword]" (e.g., "related to testing" or "related to React")

If no parameters are provided, default to analyzing the **last 10 diary entries**.

## Steps to Follow

1. **Determine project name**:
   ```bash
   PROJECT_NAME=$(git remote get-url origin 2>/dev/null | sed 's|.*/||; s|\.git$||' || basename "{{ cwd }}")
   ```
   This resolves to the git repo name (e.g., `rcm_qp_drake`), which stays consistent across worktrees. Falls back to directory basename for non-git projects.

2. **Check processed entries log**:
   - Read `~/.claude/diary/${PROJECT_NAME}/reflections/processed.log` to find already-processed diary entries
   - Format: `[diary-filename] | [reflection-date] | [reflection-filename]`
   - Example: `2025-11-07-session-1.md | 2025-11-08 | 2025-11-reflection-1.md`
   - If file doesn't exist, all entries are unprocessed
   - Create the file if it doesn't exist: `touch ~/.claude/diary/${PROJECT_NAME}/reflections/processed.log`

3. **Locate diary entries**:
   - Directory: `~/.claude/diary/${PROJECT_NAME}/`
   - Entries are named: `YYYY-MM-DD-session-N.md`
   - List all entries, sorted by date (newest first)
   - **Exclude already-processed entries** (unless user explicitly requests re-analysis)

4. **Filter entries based on parameters**:
   - If date range specified: only include entries within that range
   - If entry count specified: take the N most recent entries
   - If pattern filter specified: only include entries that mention the keyword in any section

5. **Read and parse filtered diary entries**:
   - Read each diary entry file
   - Extract information from all sections
   - Pay special attention to:
     - User Preferences Observed
     - Code Patterns and Decisions
     - Solutions Applied (what works well)
     - Challenges Encountered (what to avoid)

6. **Create the reflections directory** (if it doesn't exist):
   - Directory: `~/.claude/diary/${PROJECT_NAME}/reflections/`
   - Use `mkdir -p` to create it automatically

7. **Read current CLAUDE.md to check for existing rules**:
   - Read `{{ cwd }}/CLAUDE.md` to understand what rules already exist
   - This is CRITICAL for the next step

8. **Analyze entries for patterns AND rule violations**:
   - **Frequency analysis**: What preferences/patterns appear in multiple entries?
   - **Consistency check**: Are preferences consistent or contradictory?
   - **Context awareness**: Do patterns apply globally or to specific project types?
   - **Abstraction level**: Can specific instances be generalized into rules?
   - **Signal vs. noise**: Distinguish between:
     - **One-off requests**: "Make this button pink" (appears once)
     - **Recurring patterns**: "Always use TypeScript strict mode" (appears 3+ times)
   - **CRITICAL - Rule Violation Detection**: Check if diary entries show violations of EXISTING CLAUDE.md rules
     - Look in "Code Review & PR Feedback", "Challenges Encountered", "User Preferences Observed" sections
     - If a diary mentions user correcting Claude for violating an existing rule, this is HIGH PRIORITY
     - Example: CLAUDE.md says "no AI attribution" but diary shows "User corrected: Don't add Claude attribution"
     - These violations mean the existing rule needs STRENGTHENING (more explicit, moved to top, zero tolerance language)

9. **Synthesize insights** organized by category:

   **CRITICAL**: Focus on extracting concise, actionable rules suitable for CLAUDE.md (which is read into every session).

   **PRIORITY: Rule Violations** (MUST address first):
   - Did any diary entries document violations of existing CLAUDE.md rules?
   - If YES, these are HIGHEST PRIORITY and require rule strengthening
   - Document the violation pattern and propose specific strengthening

   **A. Persistent Preferences** (appear 2+ times)
   **B. Design Decisions That Worked**
   **C. Anti-Patterns to Avoid** (caused problems 2+ times)
   **D. Efficiency Lessons**
   **E. Project-Specific Patterns**

10. **Generate a reflection document** and save to `~/.claude/diary/${PROJECT_NAME}/reflections/YYYY-MM-reflection-N.md`

11. **Propose CLAUDE.md updates (requires user approval)**:
   - Present rules to strengthen and new rules to add
   - Do NOT modify CLAUDE.md until user explicitly approves
   - If rejected, save proposals in the reflection document

12. **Update processed entries log**:
   - Append to `~/.claude/diary/${PROJECT_NAME}/reflections/processed.log`
   - Format: `[diary-filename] | [YYYY-MM-DD] | [reflection-filename]`

## Important Guidelines

### Pattern Recognition Principles

1. **Frequency matters**: Require 2+ occurrences before calling something a "pattern"
2. **Context matters**: Note whether patterns are universal or project-specific
3. **Consistency matters**: Flag contradictory preferences for user review
4. **Actionability matters**: Only propose rules that Claude can actually follow
5. **Succinctness matters for CLAUDE.md**: One line per rule, imperative tone

### Quality Checks

Before proposing a CLAUDE.md update, verify:
- Does this apply to future sessions?
- Is this actionable?
- Is this generalizable?
- Is this consistent with other patterns?
- Is this valuable?

## Error Handling

- If no diary entries exist, inform the user and suggest running `/diary` first
- If all entries have been processed, inform the user
- If fewer than 3 entries, proceed but note low pattern confidence

## Example Usage

```
/reflect                                    # Last 10 unprocessed entries
/reflect last 20 entries                    # Last 20
/reflect from 2025-01-01 to 2025-01-31     # Date range
/reflect related to testing                 # Filtered
/reflect include all entries                # Re-analyze everything
```
