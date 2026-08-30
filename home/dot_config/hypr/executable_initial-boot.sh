#!/usr/bin/env bash
set -euo pipefail

marker="$HOME/.config/hypr/.initial_startup_done"
wallpaper="$HOME/Pictures/wallpapers/Fantasy-Landscape.png"

if [[ -f "$marker" ]]; then
  exit 0
fi

if [[ -f "$wallpaper" ]]; then
  ready=false

  for _ in {1..20}; do
    if awww query >/dev/null 2>&1; then
      ready=true
      break
    fi
    sleep 0.1
  done

  if [[ "$ready" != true ]]; then
    exit 0
  fi

  awww img "$wallpaper"
fi

touch "$marker"
