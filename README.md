# My Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## 🚀 Installation

### One-line Install (Recommended)

Requires `git` and `curl` (and `sudo` for package installation).

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $USER
```

### Manual Install

If you already have `chezmoi` installed:

```bash
chezmoi init --apply $USER
```

Or clone manually:

```bash
git clone https://github.com/notrodans/dotfiles.git ~/.local/share/chezmoi
chezmoi init --apply
```

## 🛠 Features

*   **OS**: Arch Linux (primary), basic support for others.
*   **Window Manager**: Hyprland (with Waybar, Rofi, Wlogout).
*   **Shell**: Zsh + Oh My Zsh + Powerlevel10k (if configured).
*   **Terminal**: Kitty.
*   **Editor**: Neovim.
*   **Dev Tools**:
    *   **SDKMAN**: Java version management.
    *   **NVM**: Node.js version management.
    *   **TPM**: Tmux Plugin Manager.
*   **Package Management**:
    *   Declarative package management via `home/.packages.yaml`.
    *   Automatically installs Arch Linux packages via `paru` (AUR helper).
*   **Secrets Management**:
    *   Integrated with **Bitwarden** for secure token and password handling (e.g., MCP tokens).

## 📂 Structure

*   `home/` - The source state of your home directory.
*   `home/.packages.yaml` - Declarative list of packages to install.
*   `home/.chezmoiscripts/` - Installation hooks (run automatically during `chezmoi apply`).
    *   `linux/run_once_after_00-install-packages.sh.tmpl` - Installs system packages from YAML.
    *   `run_onchange_after_10-install-tools.sh.tmpl` - Installs userspace tools (SDKMAN, NVM, etc.).
*   `tests/` - Multi-arch Docker testing suite.

## 🔐 Secrets (Bitwarden)

To use templates that require secrets (like MCP tokens):
1.  Ensure `bw` (Bitwarden CLI) is installed.
2.  Unlock your vault: `export BW_SESSION=$(bw unlock --raw)`.
3.  Run `chezmoi apply`.

## 🧪 Testing

Test your dotfiles in a clean container (supports `x86_64` and `ARM64`):

```bash
# Automated test
./tests/run-test.sh linux/amd64 --test

# Interactive shell
./tests/run-test.sh linux/arm64
```

## 💻 Known Working Hardware

These dotfiles are tested and working stably on the following hardware:

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
| `chezmoi apply` | **Apply** changes from source state to destination (home dir) |
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
