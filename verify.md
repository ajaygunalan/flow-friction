---
description: Verify implementation matches the plan
allowed-tools: Read, Glob, Grep, Bash, TaskList
---

# Verify Implementation

Compare what was built against the plan. Check alignment.

## Phase 0: Risk Assessment (Optional)

Is this implementation critical? (security, data integrity, core functionality)

If yes, read @.claude/commands/think/inversion.md and apply it:
- What would guarantee this verification misses bugs?
- What failure modes might we overlook?
- Ensure verification covers these risks

Skip this phase for routine implementations.

## Phase 1: Read the Plan

Find the most recent file in `docs/plan/` (excluding RESEARCH.md).

2. **Check task completion** - Use TaskList to see what was done.

3. **Verify each requirement** - For each item in the plan:
   - Does the code exist?
   - Does it match the spec?
   - Are tests passing?

4. **Report findings**:
   - What's complete and aligned
   - What's missing or different
   - Any discrepancies between plan and implementation

Do not fix anything. Just report.
