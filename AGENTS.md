# Agent Instructions for Dotfiles Repository

This repository is managed with [chezmoi](https://www.chezmoi.io/). It features a declarative package management system and Bitwarden integration for secrets.

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

### 1. File Organization
- **Source Root**: All managed files reside in the `home/` directory.
- **Hidden Files**: Managed hidden files must be prefixed with `dot_` (e.g., `home/dot_zshrc.tmpl`).
- **Templates**: Any file containing logic, environment variables, or secrets **must** have the `.tmpl` extension.

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
- **Fallbacks**: Provide a `PLACEHOLDER` or safe default if `.secrets` is false.

---

## 🧪 Workflow for Agents

1.  **Analyze**: Locate the target file in `home/`. Check for a `.tmpl` version.
2.  **Verify Context**: Run `chezmoi data` to understand environment variables.
3.  **Implement**: Apply changes to the source files in `home/`.
4.  **Validate Template**: Use `chezmoi execute-template < path/to/file.tmpl`.
5.  **Dry-Run**: Execute `chezmoi apply --dry-run -v`.
6.  **Test**: If changes affect installation or packages, run the Docker testing suite.
7.  **Commit**: Create atomic, descriptive commits (e.g., `fix(packages): add ripgrep to nvim deps`).
