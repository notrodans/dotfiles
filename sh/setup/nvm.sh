#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"

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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nvm
fi
