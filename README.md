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
    *   Automatically installs Arch Linux packages via `paru` (AUR helper).

## 📂 Structure

*   `home/` - The source state of your home directory.
*   `home/.chezmoiscripts/` - Installation hooks (run automatically during `chezmoi apply`).
    *   `linux/run_once_after_00-install-packages.sh.tmpl` - Installs system packages (Arch/Pacman/Paru).
    *   `run_onchange_after_10-install-tools.sh.tmpl` - Installs userspace tools (SDKMAN, NVM, etc.).

## 🔄 Management

*   **Apply changes**: `chezmoi apply`
*   **Edit a file**: `chezmoi edit ~/.config/kitty/kitty.conf`
*   **Add a file**: `chezmoi add ~/.bashrc`
*   **Update dotfiles**: `chezmoi update` (pulls from git and applies)
