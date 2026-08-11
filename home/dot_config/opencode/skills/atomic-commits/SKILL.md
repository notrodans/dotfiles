---
name: atomic-commits
description: Plan or create focused Git commits only after the user explicitly asks.
---

# Atomic Commits

Activate only when the user explicitly requests commit planning or creating
commits. Do not infer permission from completed implementation, review,
approval, or commit-message drafting. If scope is ambiguous, return a concise
block stating the missing scope; do not start a long interview.

## Inspect and group

- Inspect `git status --short`, staged diffs, and relevant unstaged diffs before
  proposing or making a commit.
- Group independent intents into separate commits. Keep coupled code, tests, and
  configuration together when they serve one intent.
- Preserve unrelated dirty changes and staged user work. Stage only intended
  paths; never reset, restore, or overwrite work you do not own.

## Commit rules

- Run narrow, relevant checks when practical and report the checks and results.
- Every commit MUST follow Conventional Commits 1.0.0:
  `<type>[optional scope][optional !]: <description>`.
  Use lowercase types; `feat` for a new feature and `fix` for a bug fix. Other
  valid types include `build`, `chore`, `ci`, `docs`, `perf`, `refactor`,
  `style`, and `test`. Keep the description concise and imperative.
- Every commit MUST include a body, even though Conventional Commits makes it
  optional. Separate it from the header with one blank line and write:
  `What: <what changed>` and `Why: <why it changed>`.
- Mark breaking changes with `!` immediately before `:` or a separate
  `BREAKING CHANGE: <description>` footer. Separate footers from the body with
  one blank line; `BREAKING CHANGE` must be uppercase.
- Do not edit code merely to make a commit.
- Do not push.
- Create a commit only after explicit authorization. Report its hash, **What**
  changed, **Why** it belongs in that commit, and checks.

For planning, show each proposed commit's **What** (change), **Why** (reason),
paths, message, and checks. Keep What/Why to one short sentence each.
Planning must not stage, commit, or push.
