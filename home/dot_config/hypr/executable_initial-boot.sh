#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
marker="$state_dir/initial-startup-done"
legacy_marker="$HOME/.config/hypr/.initial_startup_done"
wallpaper="$HOME/Pictures/wallpapers/Fantasy-Landscape.png"

mkdir -p "$state_dir"

if [[ -f "$marker" ]]; then
  exit 0
fi

if [[ -f "$legacy_marker" ]]; then
  mv "$legacy_marker" "$marker"
  exit 0
fi

if [[ ! -f "$wallpaper" ]]; then
  exit 0
fi

for _ in {1..20}; do
  if awww query >/dev/null 2>&1; then
    awww img "$wallpaper"
    touch "$marker"
    exit 0
  fi

  sleep 0.1
done

exit 0
