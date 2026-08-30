# Agent Instructions for Dotfiles Repository

This repository is managed with [chezmoi](https://www.chezmoi.io/). It features a declarative package management system, an OpenCode agent harness, and Bitwarden integration for secrets.

## 🛠 Critical Commands

### Daily Chezmoi Operations
- **Apply changes**: `chezmoi apply -v`
  *Note: Always use verbose mode to monitor script output.*
- **Check template data**: `chezmoi data`
- **Test template expansion**: `chezmoi execute-template < path/to/file.tmpl`
- **Launch source shell**: `chezmoi cd`
- **Edit source file**: `chezmoi edit ~/.config/nvim/init.lua`

### Testing Suite (Docker)
- **Run automated test**: `./tests/run-test.sh linux/amd64 --test`
- **Interactive test shell**: `./tests/run-test.sh linux/amd64`
  *Inside the container, run the `test` command to trigger the full installation.*

---

## 📐 Code Style & Conventions

- Preserve existing dirty changes. Do not overwrite, revert, reformat, or move user/agent changes unless the task explicitly asks for it.
- Commits are only allowed when explicitly requested by the user.

### 1. File Organization
- **Source Root**: All managed files reside in the `home/` directory.
- **Hidden Files**: Managed hidden files must be prefixed with `dot_` (e.g., `home/dot_zshrc.tmpl`).
- **Templates**: Any file containing logic, environment variables, or secrets **must** have the `.tmpl` extension.
- **Generated artifacts**: Generated OpenCode package artifacts are unmanaged; change the source config under `home/`, not generated output.

### 2. Shell Scripts (`.sh`, `.sh.tmpl`)
- **Safety**: Always include `set -euo pipefail` at the top of scripts.
- **Logging**: Use the defined `info "message"` and `warn "message"` helpers.
- **Portability**: Fallback for `USER` using `USER=${USER:-$(id -un)}`.
- **Systemd**: Check for systemd availability before calling `systemctl`:
  ```bash
  if [[ -d /run/systemd/system ]]; then
    sudo systemctl enable --now service_name
  fi
  ```
- **Sudo**: Use `sudo -n` for non-interactive checks.

### 3. Chezmoi Templating
- **Whitespace**: Use `{{-` and `-}}` to strip leading and trailing whitespace.
- **Paths**: Never hardcode `/home/user`. Always use `{{ .chezmoi.homeDir }}`.
- **Logic**: Use `{{ if eq .chezmoi.os "linux" }}` for OS-specific configurations.

---

## 📦 Package Management

Packages are managed declaratively through `.packages.yaml` files. **NEVER** hardcode `paru` or `pacman` commands in shell scripts.

Declare new package dependencies in `.packages.yaml`; do not install them imperatively from scripts unless the package system already handles that tool class.

### How to add packages:
1.  **Global Packages**: Edit `home/.packages.yaml`.
2.  **Component Packages**: Create/edit a `.packages.yaml` in the component's directory (e.g., `home/dot_config/nvim/.packages.yaml`).
3.  **Automatic Discovery**: The system discovers and merges all files named `.packages.yaml` within the `home/` directory.
4.  **Format**:
    ```yaml
    packages:
      category_name:
        - package-name
    ```

---

## 🔐 Secrets & Security

All sensitive data (tokens, API keys) must be retrieved from **Bitwarden**.

- **Template Condition**: Only attempt to retrieve secrets if the `.secrets` flag is enabled:
  ```tmpl
  {{- if .secrets }}
  api_key: {{ (bitwarden "item" "my-secret-item").login.password }}
  {{- end }}
  ```
- **Bitwarden Items**: Use specific names for items:
  - `fastmcp-key`: Used for FastMCP gateway access.
  - `github-token`: Used for GitHub MCP and API access.
  - `dockerhub-token`: Used for Docker Hub access.
- **No placeholders**: Do not write placeholder credentials. Secret-backed MCP entries must be omitted when `.secrets` is false; missing Bitwarden items must fail rendering clearly.
- **FastMCP caveat**: FastMCP requires its token in the query string; preserve that form without hardcoding the token.

---

## OpenCode Harness Source Map

- `home/dot_config/opencode/private_opencode.json.tmpl` - Main generated private config, plugin registration, permissions, LSPs, and secret-backed MCP entries.
- `home/dot_config/opencode/tui.json` - TUI settings.
- `home/dot_config/opencode/oh-my-opencode-slim.json` - Active agent presets and orchestration settings.
- `home/dot_config/opencode/oh-my-opencode-slim/` - Prompt extensions for built-in agents.
- `home/dot_config/opencode/commands/` - Slash commands; keep exactly scoped command files concise and deterministic.
- `home/dot_config/opencode/skills/` - Skills; keep them reusable, focused, and documented in-file.

Harness notes:
- The active preset is `openai-lean`; configured alternatives are `openai` and `opencode-go`. Do not add cross-provider fallback behavior.
- Preserve tmux specialist-pane conventions when editing commands or skills.
- Restart OpenCode after config, command, skill, or MCP changes.

---

## 🧪 Workflow for Agents

1.  **Analyze**: Locate the target file in `home/`. Check for a `.tmpl` version.
2.  **Verify Context**: Run `chezmoi data` to understand environment variables.
3.  **Unlock Secrets**: Before rendering, status checks, or dry-runs with `.secrets` enabled, require a valid `BW_SESSION`. If Bitwarden is unavailable, report the validation as blocked instead of prompting or weakening the template.
4.  **Implement**: Apply changes to the source files in `home/`.
5.  **Validate Templates**: Use `chezmoi execute-template < path/to/file.tmpl` for changed templates.
6.  **Harness Validation**: For OpenCode changes, run `OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json" bunx oh-my-opencode-slim@latest doctor`.
7.  **Dry-Run**: Execute `chezmoi apply --dry-run -v`.
8.  **Test**: If changes affect installation or packages, run the Docker testing suite.
