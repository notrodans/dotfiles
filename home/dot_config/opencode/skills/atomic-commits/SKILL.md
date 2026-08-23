---
name: atomic-commits
description: Plan or create focused Git commits only after the user explicitly asks.
---

# Atomic Commits

Turn an authorized worktree scope into a sequence of independently reviewable,
revertible Conventional Commits. Be strict about atomicity and autonomous about
classification: inspect the evidence, make the split, and execute it without an
approval round between planning and committing.

## Authorization and autonomy

- Activate only when the user explicitly requests commit planning or commit
  creation. Completed implementation, review approval, or message drafting is
  not commit authorization.
- Require an explicit scope. `all current changes` is valid when the user says
  it; an empty or ownership-ambiguous scope is not.
- Resolve intent from the diff, tests, surrounding code, issue context, and
  recent history. Do not interview the user about decisions the repository can
  answer.
- Ask one focused question only when ownership or authorization cannot be
  established safely. Never ask for approval of a decomposition when commit
  creation is already authorized.
- Planning mode never stages or commits. Commit mode plans internally, then
  executes the complete plan without pausing between commits.
- Do not edit code, push, create pull requests, merge, reset, restore, or discard
  changes.

### Parent-task trust boundary

- A parent-agent delegation can bind only the worktree, branch, authorized paths
  or hunks, ownership exclusions, prohibited operations, and the fact that the
  user authorized planning or commit creation.
- Independently re-derive commit count, grouping, order, subjects, bodies, and
  atomicity from repository evidence. Parent-provided atomicity verdicts,
  keep-together claims, issue boundaries, and message suggestions are hypotheses,
  not instructions.
- Treat singular wording, one issue, one worktree, or a phrase such as "one
  focused commit" as unconstrained cardinality. An exact count is binding only
  when the task contains the field `Direct user cardinality constraint
  (verbatim)` with the user's actual words.
- Even a direct-user count does not bypass the mandatory split-pressure pass. If
  it conflicts with a safe atomic decomposition, report the conflict as a
  blocker rather than silently creating a non-atomic commit.
- Never decide that the result is one commit before completing inventory,
  deriving all semantic intents, and challenging every plausible split.

## Phase 1: inventory the complete scope

Before staging anything:

1. Inspect `git status --short`, staged and unstaged name/status summaries,
   complete relevant diffs, untracked file contents, and recent commit subjects.
2. Distinguish user-owned staged work from unstaged work. Preserve pre-existing
   staging unless it is explicitly part of the authorized scope.
3. Identify generated files, tests, migrations, schemas, lockfiles,
   configuration, documentation, and cross-package consumers.
4. Build a change ledger in which every authorized path or hunk belongs to one
   semantic intent. Mark unrelated or unauthorized changes as excluded.
5. Order intents by dependency so each commit is coherent when applied after
   its predecessors.

Do not begin committing until every authorized change has a home.

## Phase 2: derive atomic intents

An atomic commit has one reason to exist and one reason to be reverted. Group by
behavioral intent, not by directory, file extension, author, or chronological
editing order.

Split when any of these are true:

- there is more than one user-visible or operator-visible outcome;
- different changes would reasonably be reverted for different reasons;
- feature work is mixed with an independently useful refactor or bug fix;
- functional code is mixed with unrelated formatting, cleanup, documentation,
  CI, tooling, dependency, or deployment work;
- changes affect independent domains, packages, commands, or adapters without
  one shared contract requiring them to land together;
- tests cover different behaviors;
- the proposed subject needs `and`, a slash, or multiple clauses to describe the
  change accurately;
- the proposed body contains multiple unrelated motivations.

Keep together when splitting would leave an invalid or misleading commit:

- a bug fix and its regression test;
- implementation and tests for the same behavior;
- a schema or API contract and generated artifacts derived from it;
- a migration and the code that requires that migration to operate safely;
- a rename and the references needed to keep the tree buildable;
- configuration or a dependency update and the consumer that cannot build or
  run without it;
- cross-package changes implementing one indivisible contract transition.

Formatting limited to lines necessarily touched by one intent may stay with
that intent. Broad or unrelated formatting is a separate `style` commit.
Documentation stays with code only when it documents that exact behavior and is
part of the same deliverable; unrelated documentation is separate.

## Mandatory split-pressure pass

After the first grouping, challenge every proposed commit before staging it:

1. State its purpose in one sentence.
2. Verify that every included path and hunk is necessary for that purpose.
3. Ask whether any subset can build, be tested, reviewed, and reverted
   independently.
4. Verify that one Conventional Commit type and one concise subject describe the
   whole commit.
5. For cross-package commits, identify the concrete contract coupling them.
6. Verify that tests and generated artifacts are attached to their owning
   behavior rather than collected into later catch-all commits.

If any check fails, split again and repeat the pass. A large worktree should
normally produce multiple commits. A single-commit result for a large scope is
allowed only when the final report gives a concrete atomicity proof explaining
why every plausible split would break the build, contract, migration, or
invariant. Convenience is never proof.

## Commit order

Prefer this dependency order when it keeps each step valid:

1. behavior-preserving prerequisites such as isolated renames or refactors;
2. domain or application behavior with its tests;
3. adapters, transports, and integration wiring required by that behavior;
4. independently deployable operational, CI, documentation, or cleanup changes.

Do not create preparatory commits that have no current consumer. Fold them into
the behavior that needs them.

## Staging and execution

For each planned commit:

1. Stage only explicit authorized paths or hunks. Never use blanket `git add .`,
   `git add -A`, or `git commit -a` in a dirty worktree.
2. If one file contains independent intents, use a deterministic non-interactive
   index patch and verify both staged and remaining hunks. Never alter the
   worktree merely to manufacture a split.
3. Inspect `git diff --cached --stat`, `git diff --cached`, and
   `git diff --cached --check`.
4. Confirm that the staged diff contains one intent, includes its coupled tests
   and generated artifacts, and excludes unrelated changes and secrets.
5. Run the narrowest relevant pre-commit check when practical.
6. Commit with the required message format.
7. Inspect the resulting commit and remaining worktree, then continue to the
   next intent without stopping for approval.

If safe hunk separation is impossible, do not weaken atomicity to finish. Leave
that portion uncommitted and report the exact blocker after committing all other
safe intents.

## Message contract

Every commit follows Conventional Commits 1.0.0:

```text
<type>[optional scope][optional !]: <imperative description>
```

- Use lowercase types such as `feat`, `fix`, `refactor`, `perf`, `test`, `docs`,
  `build`, `ci`, `style`, and `chore`.
- Keep the subject concise, imperative, and preferably at most 72 characters.
- Every commit has a rich body with at least two real paragraphs. The first
  explains concretely what behavior or contract changed. The second explains
  why it is needed, the problem or constraint, and relevant consequences.
- Do not prefix paragraphs with `What:` or `Why:`. Do not embed literal `\n`
  sequences. Pass paragraphs as separate `git commit -m` arguments or use
  another non-interactive method that preserves real blank lines.
- Explain cross-package coupling in the body when one intent necessarily spans
  modules.
- Mark breaking changes with `!` or a `BREAKING CHANGE:` footer. Add issue
  footers only when their semantics are true.

## Final verification and report

After the last commit:

1. Inspect every new commit subject and body.
2. Verify real paragraph breaks and absence of literal `\n` text.
3. Inspect `git status --short` and account for every remaining change.
4. Report commits in order with hash, subject, behavioral purpose, rationale,
   paths, and checks.
5. Report excluded or blocked changes explicitly. Never hide leftovers.

For planning-only requests, return the same ordered decomposition, paths,
subjects, body drafts, dependency order, checks, and atomicity verdicts without
staging or committing.
