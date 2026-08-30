#!/usr/bin/env bash
set -euo pipefail

export USER=${USER:-$(id -un)}
export CI=true
COMMAND=${1:-/bin/zsh}

validate_templates() {
  local template_root="$HOME/.local/share/chezmoi/home/.chezmoiscripts"
  local rendered

  printf 'INFO: Validating rendered shell templates...\n'

  while IFS= read -r -d '' template; do
    rendered=$(mktemp)
    chezmoi execute-template < "$template" > "$rendered"
    shellcheck --severity=error "$rendered"
    rm -f "$rendered"
  done < <(find "$template_root" -type f -name '*.sh.tmpl' -print0)
}

validate_installation() {
  printf 'INFO: Validating generated configuration...\n'

  zsh -n "$HOME/.zshrc"

  while IFS= read -r -d '' script; do
    bash -n "$script"
  done < <(find "$HOME/.config/hypr" -type f -name '*.sh' -print0)

  while IFS= read -r -d '' config; do
    luac -p "$config"
  done < <(find "$HOME/.config/hypr" -type f -name '*.lua' -print0)

  mapfile -d '' -t units < <(
    find "$HOME/.config/systemd/user" -maxdepth 1 -type f \
      \( -name '*.service' -o -name '*.target' \) -print0
  )
  if ((${#units[@]} > 0)); then
    systemd-analyze --user verify "${units[@]}"
  fi

  tmux -L dotfiles-test -f "$HOME/.tmux.conf" new-session -d -s config-check
  tmux -L dotfiles-test kill-server
}

if [[ "$COMMAND" == "test" ]]; then
  printf 'INFO: Starting automated installation test...\n'
  chezmoi init --apply --verbose --force
  validate_templates
  validate_installation
  printf 'INFO: Installation and validation successful!\n'
  exit 0
fi

exec "$@"
