#!/usr/bin/env bash
set -euo pipefail

# basic logging
info() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*" >&2; }
die()  { printf "[ERR ] %s\n" "$*" >&2; exit 1; }

# repo root
: "${REPO_ROOT:=$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

# portable-ish realpath
canonpath() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$p"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' -- "$p"
  else
    # Best-effort fallback; readlink -f not on all BSDs
    readlink -f "$p" 2>/dev/null || printf "%s\n" "$p"
  fi
}
