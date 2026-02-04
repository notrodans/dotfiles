#!/usr/bin/env bash
set -e

PLATFORM=${1:-"linux/amd64"}

cd "$(dirname "$0")/.."

echo "🌍 Target Platform: $PLATFORM"

if [ "$PLATFORM" != "linux/amd64" ]; then
    echo "🛠 Setting up QEMU emulation..."
    docker run --privileged --rm tonistiigi/binfmt --install all > /dev/null
fi

echo "🚀 Building testing image for $PLATFORM..."
docker buildx build --platform "$PLATFORM" -t "dotfiles-test-${PLATFORM//\//-}" -f tests/Dockerfile . --load

echo "🛠 Starting container ($PLATFORM)..."
if [[ "$*" == *"--test"* ]]; then
    echo "💡 Running automated test..."
    docker run --rm \
        --platform "$PLATFORM" \
        --name "dotfiles-test-auto-${RANDOM}" \
        "dotfiles-test-${PLATFORM//\//-}" \
        test
else
    echo "💡 Entering interactive shell. To test installation run: test"
    docker run -it --rm \
        --platform "$PLATFORM" \
        --name "dotfiles-test-interactive-${RANDOM}" \
        "dotfiles-test-${PLATFORM//\//-}" \
        /bin/zsh
fi
