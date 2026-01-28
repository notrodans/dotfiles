#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../lib/common.sh
. "$(dirname "$0")/../lib/common.sh"

install_sdkman() {
  if [[ -d "$HOME/.sdkman" ]]; then
    info "SDKMAN already installed at $HOME/.sdkman"
  else
    info "Installing SDKMAN..."
    # Using non-interactive installation where possible
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
  fi

  # Load SDKMAN to use 'sdk' command in the current script
  export SDKMAN_DIR="$HOME/.sdkman"
  # shellcheck disable=SC1091
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

  if command -v sdk >/dev/null 2>&1; then
    info "Installing Java versions via SDKMAN..."
    # Ensure zip/unzip are available as SDKMAN depends on them
    if ! command -v zip >/dev/null 2>&1 || ! command -v unzip >/dev/null 2>&1; then
       warn "zip/unzip not found. SDKMAN might fail to install packages."
    fi

    # Install requested Java versions
    sdk install java 21.0.2-tem || true
    sdk install java 17.0.10-tem || true
    sdk install java 11.0.22-tem || true
    sdk default java 21.0.2-tem
    
    sdk version
  else
    warn "SDKMAN was installed but 'sdk' command is not available in current shell."
  fi
}

# If the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_sdkman
fi
