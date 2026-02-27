# The Five Principles of the Brainstorm Skill

Distilled through 3-agent adversarial debate (Reductionist, Structuralist, Phenomenologist) across 4 phases: independent extraction → cross-critique → synthesis → verification.

Every tactical rule in SKILL.md derives from these five. No principle is redundant — removing any one leaves rules ungrounded.

---

## P1 — Artifact as Residue

Thinking is the goal. Writing is a byproduct that must be earned by demonstrated value, not assumed as the output of a brainstorm. Conversation is a first-class outcome.

**Rules derived:**
- Don't explore the codebase without concrete reason — start the conversation
- Match existing milestone or create new (don't generate artifacts when existing thinking can be built on)
- Create file only when something worth capturing emerges — not before
- Just conversation is a valid outcome — no file needed
- Don't push toward a file
- After 4+ substantive exchanges, offer once to capture — then respect the answer
- Write issues as they crystallize — not before, not after
- Issues start with only "What are we solving?" filled — rest stays empty until earned

---

## P2 — Convergence Is Finite; Exploration and Resolution Are Incompatible Modes

Open questions accumulate entropy. Each unresolved question is a debt, not a free asset. Worse, exploration and resolution are cognitively incompatible — running both simultaneously degrades both. The skill's job is to detect which mode is active, protect it, and enforce transitions deliberately.

**Rules derived:**
- Default to deciding mode if more open than decided on entry
- When user wants to decide → stop exploring, propose concrete answers, move through one at a time
- One question at a time — before opening new, check current is resolved
- Convergence check every 3-4 exchanges: count open vs. decided, surface divergence
- Don't keep opening if user hasn't closed previous questions
- Surface when exploration without convergence stalls
- Done-ness progression: solving → building → verifying → reviewed
- When done, pick first unblocked issue, start new session in plan mode

---

## P3 — Stance Mirrors Epistemic State; AI Holds Structure, User Holds Content

The right intervention depends entirely on where the user is (confident, stuck, pushing back, deciding) — not on a fixed script. The AI's role is structural: track inventory, surface state, apply pressure, propose. The user's role is content: decide, approve, redirect, or override. Where the user needs to move (stuck or deciding), prefer concrete proposals and options over open questions — humans advance by reacting, not by generating from nothing.

**Rules derived:**
- On existing milestone: count decided vs. open, brief user in 2-3 sentences (AI tracks; user is briefed)
- User confident → challenge them ("What breaks if X happens?") — structural pressure, not content correction
- User stuck → give concrete options with tradeoffs, something to react to — AI proposes, user selects
- User pushes back → they know something you don't, ask what — user has content authority
- User wants to decide → stop exploring, propose concrete answers not questions
- Read whole file silently, brief user, then follow their lead
- A decided item with imperfect wording is still decided — fix wording, don't reopen (AI fixes structure; user's decision stands)
- Trim only what the user approves
- If file edited after review, note change and ask if review still holds

---

## P4 — Artifacts Contain Only What Inference Cannot Supply

Every line in the file must fail the test: "Would plan mode figure this out from the codebase?" If it passes, cut it. The file's signal degrades with every sentence that a capable builder could derive without it. This applies to what is written, how much detail is included, and how verification is defined.

**Rules derived:**
- Surface bloat — things the codebase already handles, implementation details a builder would figure out
- "Would plan mode figure this out from the codebase? If yes, cut it"
- Surface contradictions — conflicting issues, misaligned decisions
- Set `reviewed: true` when user is satisfied (certification that artifact passes the filter)
- `reviewed: false` frontmatter flag (tracks filter state)
- Four-quadrant frame (solving/building/verifying/need-to-know) at milestone and issue level — each quadrant captures a distinct category of irreducible content
- Focus on verification risk — hardest to check, where the boundaries are (verification criteria are what inference most struggles to supply)

---

## P5 — The Execution Context Is the Unit of Decomposition

Issues must fit within a single bounded execution context (~150k tokens, ~500 lines of spec, one Claude Code session). This constraint is not a size preference — it is the grammar of what counts as one issue vs. a milestone vs. a facet. Dependency structure, parallelism, and verification scope are all governed by this boundary.

**Rules derived:**
- Surface dependency tensions — name what can't start until another finishes
- Name what could be parallel
- Make tradeoffs visible
- Each issue plannable and implementable in one Claude Code session (~150k context)
- Full spec describable in ~500 lines? If not, split
- Interdependent sub-questions = one issue with facets (don't split)
- Independent sub-questions = separate issues
- Each verification checkbox must be binary pass/fail — checkable within execution context
- "Blocked by" line for dependent issues; omit for independent
- Use issue titles as identifiers in "Blocked by" — avoid renaming casually

---

## Derivation Proof

43 rules enumerated from SKILL.md. 42 derive from the principles. 1 is a mechanical convention.

| Rule | Principle |
|------|-----------|
| R1: Don't explore codebase without concrete reason | P1 |
| R2: Match existing milestone or create new | P1 |
| R3: Create file only when worth capturing emerges | P1 |
| R4: Entry briefing on existing milestone | P3 |
| R5: Default to deciding mode if more open than decided | P2 |
| R6: Just conversation is valid | P1 |
| R7: Don't push toward a file | P1 |
| R8: Offer once after 4+ exchanges, then respect | P1 |
| R9: Challenge confident users | P3 |
| R10: Give options to stuck users | P3 |
| R11: Yield to pushback | P3 |
| R12: Stop exploring when deciding; propose answers | P2 + P3 |
| R13: One question at a time | P2 |
| R14: Convergence check every 3-4 exchanges | P2 |
| R15: Don't open more if previous unclosed | P2 |
| R16: Write issues as they crystallize | P1 |
| R17: Issues start with only "solving?" filled | P1 |
| R18: Surface exploration-without-convergence stall | P2 |
| R19: Surface dependency tensions | P5 |
| R20: Name parallel issues | P5 |
| R21: Make tradeoffs visible | P5 |
| R22: One session per issue (~150k) | P5 |
| R23: ~500 line spec limit; split if over | P5 |
| R24: Interdependent sub-questions = one issue | P5 |
| R25: Independent sub-questions = separate issues | P5 |
| R26: Focus on verification risk / boundaries | P4 |
| R27: Binary pass/fail verification criteria | P5 |
| R28: Read file silently, brief user, follow lead | P3 |
| R29: Surface bloat | P4 |
| R30: "Would plan mode figure this out?" test | P4 |
| R31: Surface contradictions | P4 |
| R32: Fix wording, don't reopen decided items | P3 |
| R33: Trim only what user approves | P3 |
| R34: Set reviewed: true when satisfied | P4 |
| R35: Flag edits post-review, ask if review holds | P3 + P4 |
| R36: Four-quadrant milestone frame | P4 |
| R37: Four-quadrant issue frame (identical) | P4 |
| R38: reviewed: false frontmatter | P4 |
| R39: Blocked by line / omit for independent | P5 |
| R40: Use issue titles as identifiers; don't rename | P5 |
| R41: Increment milestone id | Convention* |
| R42: Done-ness progression | P2 |
| R43: Pick first unblocked issue, new session | P2 + P5 |

*R41 is a namespace hygiene convention, not derivable from any principle.

---

## What Was Excluded and Why

**Fractal Epistemic Inventory** — The four-quadrant repetition at milestone and issue level is real but derivable from P4 applied recursively. Not a separate principle.

**Authority Asymmetry** — Absorbed into P3. Once P3's statement includes "AI holds structure, user holds content," the authority rules are generated without a separate principle.

**Reactive Cognition** — Absorbed into P3 via the clause "prefer concrete proposals over open questions." Covers two of four epistemic states (stuck, deciding) but not the other two (confident, pushback). A mechanism within P3, not a parallel principle.

---

## The Reduction Proof

These five principles are minimal: removing any one leaves rules ungrounded.

- **Without P1:** R3, R6, R7, R8, R16, R17 have no source. Nothing else generates "don't write until earned."
- **Without P2:** R5, R13, R14, R15, R18, R42 have no source. Nothing else generates convergence management.
- **Without P3:** R9, R10, R11, R28, R32, R33 have no source. Nothing else generates adaptive interaction or content authority.
- **Without P4:** R29, R30, R31, R34, R36, R37, R38 have no source. Nothing else generates artifact content filtering.
- **Without P5:** R19, R20, R22, R23, R24, R25, R27, R39, R40 have no source. Nothing else generates execution-bounded decomposition.

No principle can be dropped. No principle can absorb another without losing rule coverage. The set is minimal.
