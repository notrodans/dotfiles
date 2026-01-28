#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "Oh My Zsh already installed"
  else
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  
  if [[ "$SHELL" != */zsh ]]; then
    info "Changing shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_oh_my_zsh
fi
