---
description: Create atomic conventional commits with rich bodies
agent: commiter
---

The user explicitly authorizes creating Git commits for this scope:

$ARGUMENTS

Inspect the complete worktree before staging. If the scope is empty or ownership
cannot be established safely, stop with one concise request for the missing
scope. Resolve all other grouping decisions autonomously from repository
evidence; do not ask the user to approve the decomposition.

Split the authorized scope into independent, reviewable Conventional Commits and
apply the mandatory split-pressure pass from `atomic-commits`. A large worktree
should normally produce multiple commits; a single commit requires a concrete
atomicity proof.

Every commit must contain a rich body with real blank lines: first explain what
behavior changed, then explain why the change is needed and its relevant impact.
Do not use `What:` or `Why:` labels and do not embed literal `\n` sequences.

Continue until all safe in-scope changes are committed or a concrete safety
blocker is found. Preserve unrelated changes and user-owned staged work. Do not
modify code, push, create a pull request, or merge.
