#!/usr/bin/env bash
set -euo pipefail

wall_dir="$HOME/Pictures/wallpapers"
transition=(
  --transition-fps 60
  --transition-type wipe
  --transition-duration 1
)
fuzzel_command=(
  fuzzel
  --dmenu
  --prompt="Wallpaper › "
  --cache=/dev/null
  --minimal-lines
)

if pgrep -x fuzzel >/dev/null 2>&1; then
  pkill -x fuzzel
  exit 0
fi

if ! awww query >/dev/null 2>&1; then
  printf 'awww daemon is not available\n' >&2
  exit 1
fi

if [[ ! -d "$wall_dir" ]]; then
  printf 'Wallpaper directory does not exist: %s\n' "$wall_dir" >&2
  exit 1
fi

mapfile -d '' -t pictures < <(
  find "$wall_dir" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) \
    -print0 | sort -z
)

if ((${#pictures[@]} == 0)); then
  printf 'No wallpapers found in %s\n' "$wall_dir" >&2
  exit 1
fi

random_label="${#pictures[@]}. random"

menu() {
  local path
  local name

  for path in "${pictures[@]}"; do
    name=$(basename "$path")
    printf '%s\x00icon\x1f%s\n' "$name" "$path"
  done

  printf '%s\n' "$random_label"
}

choice=$(menu | "${fuzzel_command[@]}") || exit 0
[[ -n "$choice" ]] || exit 0

if [[ "$choice" == "$random_label" ]]; then
  selected="${pictures[RANDOM % ${#pictures[@]}]}"
else
  selected="$wall_dir/$choice"
fi

if [[ ! -f "$selected" ]]; then
  printf 'Wallpaper not found: %s\n' "$selected" >&2
  exit 1
fi

exec awww img "$selected" "${transition[@]}"
