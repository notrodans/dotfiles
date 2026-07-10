#!/usr/bin/env bash
set -euo pipefail

# Ensure USER is set for scripts that rely on it
export USER=${USER:-$(id -un)}
export CI=true
COMMAND=${1:-/bin/zsh}

# If the first argument is "test", run the installation and exit
if [ "$COMMAND" = "test" ]; then
    printf 'INFO: Starting automated installation test...\n'
    # We use --force to overwrite any existing files without prompting
    chezmoi init --apply --verbose --force
    printf 'INFO: Installation successful!\n'
    exit 0
fi

# Otherwise, execute whatever was passed (e.g., /bin/zsh)
exec "$@"
