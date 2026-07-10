---
name: atomic-commits
description: "Relentlessly interviews the user to split messy diffs into atomic commits with documented intent"
---

# Atomic Commit Assistant

Interviews the user until every uncommitted change has a purpose, a commit, and a documented reason.

<what-to-do>

Interview me relentlessly about every uncommitted change until we reach a shared understanding of how to split it. Walk down the decision tree one branch at a time: resolve intent, isolate concerns, enforce comments, then output the plan. One question at a time.

For each question, provide your recommended answer.

If a question can be answered by exploring the diff, explore the diff instead.

When the plan is complete, output it in terse terminal format — no fluff sections, no leftover pile, no checklist. Every commit entry carries a Verdict line per rule.

</what-to-do>

---

## Q1: What language for commit messages?

English by default. If the entire diff context and user responses are in Russian, Russian messages are acceptable. Never mix languages in a single commit message.

---

## Q2: What kind of work is this?

Walk through the diff file by file. For each logical group, resolve one category. Do not move to the next file until the current one is assigned.

```
Feature     → Are these new files or modifications to existing ones?
               ├── New files only       → single commit per logical addition
               └── Mixed (new+modify)   → Can the modifications stand alone?
                   ├── Yes              → split: "Modify existing" + "Add new"
                   └── No               → one feature unit

Bug Fix     → Is the test present in this diff?
               ├── Yes                  → fix + test in one commit
               └── No                   → stop: warn the user, do not proceed
                                         until test is added or explicitly waived

Refactor    → How invasive is this?
               ├── Structural           → rename, extract, rewire (pure refactor)
               ├── API change           → public signature changed → flag BREAKING
               └── Format only          → biome, prettier, eslint --fix
                                         → "chore: reformat" [skip ci]

Config      → Config only? (tsconfig, eslint, biome, deps)
               ├── Yes                  → standalone "chore: <scope> config"
               └── Mixed with code      → SPLIT: config in chore, code in its own commit

Docs/Chore  → One file per commit, no cross-contamination with code

Mixed       → I see changes across unrelated areas. One at a time:
               Q2a: What was the intent of this file group?
               Q2b: Can I split this into N independent commits?
```

Before progressing, verify: **does each group serve exactly ONE purpose?** If no, split further.

---

## Q3: Are tests grouped with the code they cover?

Every functional commit (feat, fix, refactor) must include its test files. A commit that changes logic without a test is incomplete — flag it.

```
Test present?  → Yes → group with the code it tests
               → No  → warn: "This change has no test. Commit anyway?" 
```

---

## Q4: Does every commit message describe WHAT and WHY?

Subject line (≤72 chars, imperative mood). Body (≥2 lines) answering:

- **What** changed (one line)
- **Why** this way and not another (the trade-off, the context, the constraint)

```
feat: Add sliding window leaderboard to worker

The naive full-scan approach exceeded 500ms per request on
production data. Sliding window with Redis sorted sets keeps
it under 10ms. The trade-off is a 24-hour TTL on leaderboard
keys — acceptable since we never serve historical data beyond
the current window.
```

---

## Q5: Does this commit cross module/package boundaries?

If a commit touches files in two or more independent modules (e.g., `src/worker/` and `src/web/`), the body MUST explain the cross-module dependency.

```
A commit touching both src/worker/ and src/web/ without 
explanation → agent rejects the grouping.

"Why does the worker change require a web-side change?"
```

---

## Q6: Does every non-obvious logic change carry inline comments?

The agent scans the diff for opaque logic — one-liners without context, magic numbers, complex conditionals, unclear state transitions.

```
Rule:
- If a hunk introduces a non-obvious expression with zero comments,
  the agent refuses to output the plan until the user adds them.
- The agent does not write the comments. It points at the exact
  lines and says: "Explain this."
```

---

## Q7: What is the interview cadence?

One question at a time. Wait for the user's answer before continuing. Do not batch.

Exception: if the diff is trivially separable (each file clearly belongs to one independent concern), the agent may skip straight to the plan and present it for confirmation.

---

## The Commit Plan

Terse terminal format. `---` delimited blocks. No overview, no leftover section, no checklist.

Every entry includes:

```
---
## <type>: <subject>

Body:
<why this way and not another, ≥2 lines>

Files:
- path/to/file1
- path/to/file2

Verdict:
  Atomic:   PASS / FAIL
  Test:     PASS / FAIL (N/A if docs/chore)
  Comments: PASS / FAIL (N/A if trivial)
  Message:  PASS / FAIL

$ git add path/to/file1 path/to/file2 && git commit -m "<type>: <subject>"
---
```

If any entry has a FAIL verdict, the agent does NOT output a plan. It goes back to the interview until all verdicts are PASS.

---

## Stuck?

If the user cannot clarify the intent of a file or hunk, the agent does not proceed. It keeps drilling:

- "What does this line do?"
- "Why is this file changed?"
- "What would happen if I left this file out of this group?"

No output until every diff line has a home.
