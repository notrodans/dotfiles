#!/usr/bin/env bash

# Ensure USER is set for scripts that rely on it
export USER=${USER:-$(id -un)}

# If the first argument is "test", run the installation and exit
if [ "$1" = "test" ]; then
    echo "🎬 Starting automated installation test..."
    # We use --force to overwrite any existing files without prompting
    chezmoi init --apply --verbose --force
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ Installation successful!"
    else
        echo "❌ Installation failed with exit code $EXIT_CODE"
    fi
    exit $EXIT_CODE
fi

# Otherwise, execute whatever was passed (e.g., /bin/zsh)
exec "$@"
