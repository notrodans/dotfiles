---
name: architect-grill-and-build
description: Stress-test a raw plan and convert it into independent production-deployable task files under docs/tasks/. Use when planning work that must ship as safe vertical slices rather than one giant PLAN.md.
---

<what-to-do>
Your goal is to transform the user's raw plan, bug list, TODO list, PRD, or initial concept into a task-first production delivery plan.

Do not default to a single giant `PLAN.md`. The primary output is a set of independent task documents under `docs/tasks/`. A short overview document may exist, but it must not become a gate that blocks deployment of individual tasks.

The plan is successful only when each generated task can be implemented, verified, deployed, and rolled back in production immediately after completion, without waiting for another task to be written or implemented.

## Core Principle

Every task is a vertical production slice.

A task must deliver one observable production improvement, preserve compatibility with existing production data and clients, include its own tests, include its own verification commands, include rollback guidance, and avoid depending on future tasks.

If a proposed task depends on future work, split it, inline the prerequisite into the same task, or make the prerequisite a separate independently deployable task.

## Operating Loop

Run this loop until the task graph is ready:

1. Extract user-visible or operator-visible outcomes from the raw plan.
2. Convert outcomes into candidate tasks.
3. Build a dependency graph between candidate tasks.
4. Challenge every dependency.
5. Split tasks until each task is independently deployable.
6. Grill unresolved decisions.
7. Write or update the overview and task files.
8. Verify that no ready task contains unresolved decisions.

## Independent Deployability Contract

Every task must satisfy all of these:

- It can be implemented from the current main branch.
- It does not require code from a future task.
- It can be deployed alone.
- It preserves existing production data compatibility.
- It preserves public API/client compatibility unless the task explicitly owns the migration.
- It has focused tests for the changed behavior.
- It has full verification commands.
- It has rollback or revert guidance.
- It has clear non-goals.
- It has no unresolved `needs decision`, `TBD`, `if feasible`, or `to investigate` language.

If any item fails, the task is not ready. Either split it or ask the user a hard question.

## Anti-Patterns To Reject

Reject these plan shapes:

- Horizontal layer phases such as `domain layer`, `repository layer`, `service layer`, then `HTTP layer` when none are deployable alone.
- Batch gates where unrelated fixes wait for each other.
- Tasks that only prepare abstractions for future work.
- Tasks that require generated SDK changes from a later task.
- Tasks that say `if needed` for core implementation decisions.
- Tasks with unresolved edge cases.
- Tasks whose tests are deferred to another task.
- Tasks that require manual production cleanup without a rollback plan.

## Overview Template

Create or update `docs/tasks/00-<slug>-overview.md` with this structure:

```markdown
# <Plan Name> - Deployable Task Map

## Document Control

| Attribute | Value |
|---|---|
| Status | Draft / Ready |
| Scope | <scope> |
| Rule | Every task must be independently deployable |
| Source | <raw user plan or issue> |

## Production Objective

Describe the production outcome in one short paragraph.

## Task Index

| Task | Production Outcome | Owner | Deploy Alone | Dependencies | Verification |
|---|---|---|---|---|---|
| 01 | <outcome> | <role> | Yes | None | <commands> |

Dependencies should normally be `None`. If a dependency remains, it must point only to an already deployable prerequisite task.

## Dependency Graph

Use Mermaid. Prefer a mostly flat graph. Any edge must be justified.

## Global Constraints

List constraints that apply to every task, such as compatibility, generated files, schema changes, migrations, tests, security, and release policy.

## Shared Decisions

List decisions that affect multiple tasks. Do not hide task-specific decisions here.

## Deferred Work

List explicitly rejected or deferred work. Deferred work must not be required for any ready task.

## Release Rule

Each task may be implemented, merged, deployed, and rolled back independently after its verification passes.
```

## Task File Template

Each task file must use this structure:

```markdown
# TASK NN: <Production Outcome>

## WHY

State the concrete production problem. Include who is harmed and how.

## FOR WHOM

Name the implementer role and reviewer role.

## PRODUCTION OUTCOME

State the exact behavior that will be true after this task ships.

## INDEPENDENCE CONTRACT

| Check | Answer |
|---|---|
| Deployable alone | Yes |
| Depends on future tasks | No |
| Preserves existing data | Yes |
| Preserves public clients | Yes |
| Requires migration | No / Yes, owned here |
| Requires generated SDK | No / Yes, owned here |
| Rollback | Revert this task / migration rollback details |

If any answer is not safe, split the task or ask the user.

## SCOPE

List what changes in this task.

## NON-SCOPE

List what must not be changed.

## FILES TO READ

List likely files to inspect before editing.

## FILES TO CHANGE

List expected files. This is a forecast, not a hard limit.

## IMPLEMENTATION STEPS

Use ordered, concrete steps. Steps must be executable by an implementer without reading the overview first.

## TESTS

List exact behavioral tests. Every changed behavior must be covered in this task.

## VERIFICATION

List focused and full commands.

## DEPLOYMENT

Explain deploy notes, migrations, feature flags, generated files, and runtime considerations.

## ROLLBACK

Explain how to safely revert or disable the change.

## EDGE CASES

Use a table of edge cases and required behavior.

## RELEVANT DECISIONS

List ADR/Q/COMP references or inline decisions. Every decision needed to implement this task must be present.

## DONE WHEN

List final acceptance criteria.
```

## Grilling Rules

Ask hard questions only when they affect task independence, production safety, compatibility, or testability.

Prefer questions like:

- What makes this task deployable without the next task?
- What existing clients or persisted data could break?
- Can this be split into a read-only safety improvement and a mutating cleanup?
- Does this task need a migration, and can that migration be rolled back?
- Are generated files required, and can they be avoided?
- What is the smallest production-visible behavior that can ship alone?

Do not ask broad architecture questions after enough information exists to split tasks safely.

## Split Rules

Split a task when:

- It touches unrelated runtime surfaces.
- One part is read-only and another mutates production state.
- One part changes backend contracts and another changes frontend behavior.
- One part is safe to deploy immediately and another requires migration or rollout.
- The task contains an unresolved decision.
- The task is large enough that rollback would undo multiple production outcomes.

Keep a combined task only when splitting would break compatibility or make neither half independently useful.

## Output Rules

When generating tasks, write the overview first, then the task files.

Number tasks by deployable sequence, not by architecture layer.

Use filenames:

- `docs/tasks/00-<slug>-overview.md`
- `docs/tasks/01-task-<slug>.md`
- `docs/tasks/02-task-<slug>.md`

Do not create a task that says implementation must wait for another unwritten task.

Do not leave placeholders such as `TBD`, `needs decision`, `if feasible`, or `to investigate` in a ready task.

If uncertainty remains, create a `Blocked Questions` section in the overview and keep the affected task out of the ready task list.

## Final Self-Check

Before finishing, inspect the generated task set and report:

- Which tasks are independently deployable now.
- Which tasks are blocked, and by which explicit question.
- Which dependencies remain and why they are unavoidable.
- Which generated files, migrations, or public contracts are touched per task.
- Which command verifies each task.
</what-to-do>
