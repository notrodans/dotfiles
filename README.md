# My Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## 🚀 Installation

### One-line Install (Recommended)

Requires `git` and `curl` (and `sudo` for package installation).

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/notrodans/dotfiles.git
```

### Manual Install

If you already have `chezmoi` installed:

```bash
chezmoi init --apply https://github.com/notrodans/dotfiles.git
```

Or clone manually:

```bash
git clone https://github.com/notrodans/dotfiles.git ~/.local/share/chezmoi
chezmoi init --apply
```

## 🛠 Features

*   **OS**: Arch Linux (primary), basic support for others.
*   **Hardware Detection**: Automatically detects CPU (Intel/AMD), all present GPU vendors (Intel/AMD/NVIDIA), and form factor (Laptop/Desktop) to apply specific drivers and configurations.
*   **Window Manager**: Hyprland (with Waybar, Fuzzel, Wlogout).
*   **Shell**: Zsh + Oh My Zsh.
*   **Terminal**: Kitty.
*   **Editor**: Neovim Nightly.
*   **Dev Tools**:
    *   **SDKMAN**: Java version management.
    *   **NVM**: Node.js version management.
    *   **TPM**: Tmux Plugin Manager.
*   **Package Management**:
    *   Declarative package management via `home/.packages.yaml`.
    *   Hardware-aware: Installs every relevant driver/microcode group for the detected CPU/GPU hardware.
    *   Automatically installs Arch Linux packages via `paru` (AUR helper).
*   **Secrets Management**:
    *   Integrated with **Bitwarden** for secure token and password handling (e.g., MCP tokens).

## 📂 Structure

*   `home/` - The source state of your home directory.
*   `home/.packages.yaml` - Declarative list of packages to install.
*   `home/.chezmoidata/tool-versions.yaml` - Managed Oh My Zsh, TPM, NVM, Node.js, Java, and gh-stack versions/revisions.
*   `home/.chezmoiscripts/` - Installation hooks (run automatically during `chezmoi apply`).
    *   `linux/run_onchange_after_00-install-packages.sh.tmpl` - Reconciles system packages from YAML.
    *   `run_onchange_after_10-install-tools.sh.tmpl` - Installs userspace tools (SDKMAN, NVM, etc.).
    *   `run_onchange_after_11-install-tmux-plugins.sh.tmpl` - Installs newly declared TPM plugins when `.tmux.conf` changes.
*   `tests/` - Docker testing suite.

## OpenCode Agent Harness

OpenCode is managed from chezmoi source files under `home/`:

*   `home/dot_config/opencode/private_opencode.json.tmpl` - Main generated private OpenCode config, including plugin registration, permissions, LSPs, and secret-backed MCP wiring.
*   `home/dot_config/opencode/tui.json` - TUI configuration.
*   `home/dot_config/opencode/oh-my-opencode-slim.json` - Agent presets and orchestration behavior.
*   `home/dot_config/opencode/oh-my-opencode-slim/` - Narrow prompt extensions.
*   `home/dot_config/opencode/commands/` - Slash commands.
*   `home/dot_config/opencode/skills/` - Agent skills.

The active preset is `openai-lean`; configured alternatives are `openai` and `opencode-go`. There is no cross-provider fallback: if one provider is unavailable, switch presets explicitly instead of relying on another provider automatically.

The harness includes tmux specialist panes for focused agent work and five slash commands: `/dotfiles-check`, `/repo-review`, `/research`, `/commit-plan`, and `/atomic-commit`. Commands stay small and deterministic; skills remain reusable and scoped.

MCP servers backed by secrets are omitted from generated config when secrets are disabled. When secrets are enabled, a missing or locked Bitwarden item stops template rendering instead of generating broken credentials. Required items are:

*   `fastmcp-key` - FastMCP gateway access.
*   `github-token` - GitHub MCP/API access.
*   `dockerhub-token` - Docker Hub access.

FastMCP currently requires the token as a query parameter; keep that caveat in mind when reviewing generated MCP URLs and never replace it with placeholder credentials.

Validate harness changes in this order:

```bash
export BW_SESSION=$(bw unlock --raw)
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json" bunx oh-my-opencode-slim@latest doctor
chezmoi apply --dry-run -v
```

When `.secrets` is enabled, stop and report a blocked validation if Bitwarden cannot be unlocked. Do not replace secret references with placeholders or validate against stale rendered credentials.

Restart OpenCode after config, command, skill, or MCP changes so the runtime reloads generated files.

## 🔐 Secrets (Bitwarden)

To use templates that require secrets (like MCP tokens):
1.  Ensure `bw` (Bitwarden CLI) is installed.
2.  Unlock your vault: `export BW_SESSION=$(bw unlock --raw)`.
3.  Run `chezmoi apply -v`.

### Configuration

To enable secret retrieval, your `~/.config/chezmoi/chezmoi.toml` (or `.yaml`) must have:

```toml
[data]
    secrets = true
```

When initializing, `chezmoi init` will prompt you to enable this. To re-enable it manually or fix it:

```bash
chezmoi data | grep secrets
# If false, edit your config:
chezmoi edit-config
```

## 🧪 Testing

Test your dotfiles in a clean container:

```bash
# Automated test
./tests/run-test.sh linux/amd64 --test

# Interactive shell
./tests/run-test.sh linux/amd64
```

## 💻 Known Working Hardware

These dotfiles are tested and working stably on the following hardware:

### Thinkpad T14s Gen 3 (Intel)
*   **CPU**: Intel Core i7-1280P
*   **GPU**: Intel Iris Xe Graphics
*   **RAM**: 32GB LPDDR5
*   **Kernel**: Arch Linux (Zen)

### Desktop System (AMD)
*   **CPU**: AMD Ryzen 5 5600
*   **GPU**: AMD Radeon RX 550
*   **Mobo**: ASUS TUF GAMING B550M-PLUS
*   **RAM**: 16GB DDR4
*   **Storage**: NVMe SSD (Btrfs)
*   **Kernel**: Arch Linux (Zen)

## ⌨️ Cheatsheet

### Daily Operations

| Command | Description |
| :--- | :--- |
| `chezmoi apply -v` | **Apply** changes from source state to destination (home dir), with verbose script output |
| `chezmoi edit $FILE` | **Edit** the source state of a file (opens in `$EDITOR`) |
| `chezmoi add $FILE` | **Add** a file from home dir to chezmoi management |
| `chezmoi diff` | See **diff** between target state and actual state |
| `chezmoi update` | Pull changes from git remote and **apply** them |

### Advanced / Maintenance

| Command | Description |
| :--- | :--- |
| `chezmoi cd` | Launch a shell in the source directory |
| `chezmoi status` | Show status of managed files (modified, missing, etc) |
| `chezmoi doctor` | Check for potential problems in configuration |
| `chezmoi re-add` | Re-import file from home dir (updates source state) |
| `chezmoi forget $FILE` | Stop managing a file (does not delete it from disk) |
| `chezmoi managed` | List all files currently managed by chezmoi |
