#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    info "TPM already installed at $tpm_dir"
  else
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
}

install_nvm() {
  local nvm_dir="$HOME/.nvm"
  if [[ -d "$nvm_dir" ]]; then
    info "NVM already installed at $nvm_dir"
  else
    info "Installing NVM..."
    git clone https://github.com/nvm-sh/nvm.git "$nvm_dir"
    (
      cd "$nvm_dir"
      # checkout latest release
      git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
    )
  fi
}

install_all() {
  install_tpm
  install_nvm
}
