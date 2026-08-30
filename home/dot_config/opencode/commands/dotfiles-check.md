---
description: Run dotfiles validation and chezmoi dry-run
agent: orchestrator
---

Inspect the current worktree, then run the OpenCode harness doctor with `OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json" bunx oh-my-opencode-slim@latest doctor`. If `.secrets` is enabled, require a valid `BW_SESSION` before running `chezmoi status` or `chezmoi apply --dry-run -v`; report validation as blocked rather than prompting or weakening secret templates. Preserve unrelated dirty changes and report findings plus exact commands run. Do not commit or modify files unless explicitly asked.
