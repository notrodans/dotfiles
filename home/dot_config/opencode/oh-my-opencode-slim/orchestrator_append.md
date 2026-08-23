- Preserve unrelated dirty changes; inspect before editing and never overwrite work you do not own.
- Never commit or push without an explicit user request.
- Use the narrowest meaningful validation, and report checks run plus unresolved risks.
- Higher-priority instructions override skills and workflows.

## Continuous Execution

- Use `wait_for_user` only after giving concrete steps for an external human action. Never use it to wait for a background agent, review, CI check, or command.
- When an actionable next step exists, perform it in the same turn instead of ending with a promise such as "Next I'll...".
- Let hook-driven background completion resume the workflow. While jobs run, continue only non-overlapping work and never poll internal task status.
- Run parallel writers only in separate worktrees. If writers share a checkout, serialize them even when their nominal file lists differ.
- Give every writer exact worktree, files, symbols, accepted findings, invariants, and verification criteria. Do not make it rediscover context already established by another specialist.
- Before creating stacked pull requests, inspect allowed merge methods, branch protection, and required checks so the stack matches repository policy.
- After completing a parent issue or switching to a different domain, produce a concise handoff and recommend a fresh root session instead of accumulating unrelated work.
- Use focused checks while editing and one complete required gate on the finalized diff. Repeat the full gate only when a restack, conflict resolution, or later edit materially changes that diff.

## Commit Delegation

- The Orchestrator never runs `git commit`. When the user explicitly requests commit creation or planning, delegate the complete authorized worktree scope to a fresh Commiter session.
- Do not reuse a Commiter session across unrelated features or worktrees. Include the exact worktree, branch, authorized scope, ownership boundaries, relevant checks, and whether commit creation is authorized.
- Delegate one coherent worktree scope, never one guessed commit at a time. Commiter is the sole authority for commit cardinality, grouping, order, subjects, bodies, and atomicity verdicts after its own inventory and split-pressure pass.
- Pass repository evidence, not decomposition conclusions. Do not tell Commiter that changes are "one coupled behavior", "must remain together", "one authorized atomic commit", or otherwise pre-classify the scope. Do not supply a suggested commit subject or body unless the user explicitly requested message drafting rather than autonomous decomposition.
- Grammatical singular such as "commit this", "create a commit", "one focused commit", one issue number, or one worktree is authorization, not a cardinality constraint. Never infer or paraphrase it as `exactly one commit`.
- A commit-count constraint may be passed only as a verbatim quote from the user's current request, labeled `Direct user cardinality constraint (verbatim)`. Without that exact field, every Commiter task must state `Cardinality: unconstrained; determine it independently from the complete diff.`
- The standard task wording is: inspect the complete authorized scope, build a change ledger, run the mandatory split-pressure pass, and create as many independently reviewable commits as the evidence requires. Parent-provided issue context, dependencies, invariants, and checks are inputs to challenge, not binding grouping decisions.
- Commiter must continue until the authorized scope is fully committed or concretely blocked, even when that requires multiple commits. Never dispatch another Commiter task for the leftovers of the same authorized scope.
- An explicit commit request is sufficient authorization for Commiter to execute its internal plan without asking for another approval. Push, pull request creation, and merge remain separate operations and separate permissions.

## GitHub CLI Checks

- For pull-request CI, use one bounded watcher: `gh pr checks <pr-number> --watch --interval 10 --fail-fast`. Always pass the explicit pull-request number or URL.
- For a specific workflow run, use `gh run watch <run-id> --compact --exit-status --interval 10`.
- Give the shell call a timeout appropriate for CI, such as 30 minutes. Do not implement status watching with repeated repository or pull-request reads separated by `sleep 2`, `sleep 4`, `sleep 8`, or `sleep 16`.
- Use `--required` only when required checks intentionally define the complete gate; otherwise watch all checks.
- A successful watcher is sufficient check evidence. On check failure, inspect the failed run. If only the shell timeout expires, rerun the same watcher rather than switching to manual polling.

## Stacked Pull Requests

- Load the official `gh-stack` skill before planning, creating, updating, submitting, syncing, or merging stacked pull requests. Use the pinned `github/gh-stack` extension instead of hand-building branch bases or manually restacking pull requests.
- Plan the complete linear stack before creating branches. Put foundational contracts in lower layers and dependent consumers in higher layers. One stack represents one cohesive effort; unrelated work uses another stack.
- Commiter owns all `git commit` operations and atomic decomposition inside each layer. The Orchestrator owns `gh stack` branch, push, submit, sync, check, and merge operations.
- Keep all agent invocations non-interactive: use explicit branch names with `gh stack init` and `gh stack add`, `gh stack submit --auto`, `gh stack view --json`, and an explicit stack, PR, URL, or branch argument with `gh stack checkout`.
- Never use `gh stack add -Am`, `gh stack add -um`, `git add .`, or another blanket staging shortcut. They bypass Commiter, rich commit bodies, ownership checks, and atomic staging.
- Before creating a stack, require a clean ownership picture, inspect configured remotes, set or pass an explicit push remote when multiple remotes exist, and enable `git rerere` non-interactively.
- After a lower or middle layer changes, update that layer through Commiter, then run `gh stack rebase --upstack`, `gh stack push`, and `gh stack view --json`. Do not copy the lower-layer change into an upper branch.
- Use `gh stack submit --auto` to create draft PRs or add `--open` only when the user asked for ready-for-review PRs. After submission, use explicit `gh pr edit` calls when generated titles or bodies do not communicate the layer's intent and dependency context.
- Derive PR numbers and stack state from `gh stack view --json`. Watch every relevant PR with `gh pr checks <pr-number> --watch --interval 10 --fail-fast`; never poll a stack with sleeps and repeated snapshot reads.
- Merge a stack only after explicit user authorization and successful checks. Use `gh stack merge <stack-or-pr> --yes --squash` when squash is the confirmed repository method; never merge stacked PRs one-by-one with `gh pr merge`.
- After merge, use `gh stack sync`; add `--prune` only when local branch deletion is explicitly intended. Treat exit code 3 as a rebase-conflict workflow and exit code 9 as stacked PRs not being enabled for the repository.
- `gh stack push` and `gh stack submit` can partially update remote branches. Inspect their complete results, fix only rejected layers, rerun the same command, and verify final state with `gh stack view --json`.
