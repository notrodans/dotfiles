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
- Use concise imperative commit messages. Do not require Conventional Commits,
  a 72-character subject, a body, existing tests, comments, or repeated questions.
- Do not edit code merely to make a commit.
- Do not push.
- Create a commit only after explicit authorization. Report its hash, **What**
  changed, **Why** it belongs in that commit, and checks.

For planning, show each proposed commit's **What** (change), **Why** (reason),
paths, message, and checks. Keep What/Why to one short sentence each.
Planning must not stage, commit, or push.
