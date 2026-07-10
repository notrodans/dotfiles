#!/usr/bin/env bash
set -euo pipefail

PLATFORM="linux/amd64"
MODE=""
if [[ ${1:-} == --* ]]; then
    MODE=${1:-}
else
    PLATFORM=${1:-"linux/amd64"}
    MODE=${2:-}
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd -- "$script_dir/.." && pwd -P)
cd "$repo_root"

printf 'INFO: Target Platform: %s\n' "$PLATFORM"

if [ "$PLATFORM" != "linux/amd64" ]; then
    printf 'INFO: Setting up QEMU emulation...\n'
    docker run --privileged --rm tonistiigi/binfmt --install all > /dev/null
fi

printf 'INFO: Building testing image for %s...\n' "$PLATFORM"
docker buildx build --platform "$PLATFORM" -t "dotfiles-test-${PLATFORM//\//-}" -f tests/Dockerfile . --load

printf 'INFO: Starting container (%s)...\n' "$PLATFORM"
if [[ "$MODE" == "--test" ]]; then
    printf 'INFO: Running automated test...\n'
    docker run --rm \
        --platform "$PLATFORM" \
        --name "dotfiles-test-auto-${RANDOM}" \
        "dotfiles-test-${PLATFORM//\//-}" \
        test
else
    printf 'INFO: Entering interactive shell. To test installation run: test\n'
    docker run -it --rm \
        --platform "$PLATFORM" \
        --name "dotfiles-test-interactive-${RANDOM}" \
        "dotfiles-test-${PLATFORM//\//-}" \
        /bin/zsh
fi
