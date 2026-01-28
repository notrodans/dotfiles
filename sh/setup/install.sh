#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"
# shellcheck source=./arch.sh
. "$(dirname "$0")/arch.sh"
# shellcheck source=./zsh.sh
. "$(dirname "$0")/zsh.sh"
# shellcheck source=./sdkman.sh
. "$(dirname "$0")/sdkman.sh"
# shellcheck source=./tmux.sh
. "$(dirname "$0")/tmux.sh"
# shellcheck source=./nvm.sh
. "$(dirname "$0")/nvm.sh"

install_all() {
  local os=""
  if [[ -f /etc/arch-release ]]; then
    os="arch"
  fi

  if [[ -z "$os" ]]; then
    warn "Could not automatically detect OS."
    echo "Please select your system:"
    echo "1) Arch Linux"
    echo "2) Skip system package installation"
    read -rp "Choice [1-2]: " choice
    case "$choice" in
      1) os="arch" ;;
      *) info "Skipping system package installation." ;;
    esac
  fi

  case "$os" in
    arch)
      info "Installing for Arch Linux..."
      install_arch
      install_oh_my_zsh
      install_sdkman
      ;;
    *)
      # Add other OS branches here in the future
      ;;
  esac

  install_tpm
  install_nvm
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_all
fi