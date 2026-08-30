#!/usr/bin/env bash
set -euo pipefail

pictures_dir=$(xdg-user-dir PICTURES)
screenshot_dir="$pictures_dir/Screenshots"
shader="$HOME/.config/hypr/shaders/vibrance.glsl.mustache"
timestamp=$(date '+%d-%b_%H-%M-%S')
filename="Screenshot_${timestamp}_${RANDOM}.png"
path="$screenshot_dir/$filename"

mkdir -p "$screenshot_dir"

shader_disabled=false

restore_shader() {
  if [[ "$shader_disabled" == true ]]; then
    hyprshade on "$shader" >/dev/null 2>&1 || true
  fi
}

disable_shader() {
  hyprshade off
  shader_disabled=true
  trap restore_shader EXIT
}

shot_now() {
  disable_shader
  grim - | tee "$path" | wl-copy
}

shot_area() {
  local geometry

  if ! geometry=$(slurp); then
    exit 0
  fi

  disable_shader
  grim -g "$geometry" - | tee "$path" | wl-copy
}

shot_active() {
  local window
  local class
  local geometry
  local active_path

  window=$(hyprctl -j activewindow)
  class=$(jq -r '.class // "window"' <<<"$window" | tr '/[:space:]' '__')
  geometry=$(jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' <<<"$window")
  active_path="$screenshot_dir/Screenshot_${timestamp}_${class}.png"

  grim -g "$geometry" "$active_path"
}

shot_swappy() {
  local geometry

  if ! geometry=$(slurp); then
    exit 0
  fi

  grim -g "$geometry" - | swappy -f -
}

case ${1:-} in
  --now)
    shot_now
    ;;
  --area)
    shot_area
    ;;
  --active)
    shot_active
    ;;
  --swappy)
    shot_swappy
    ;;
  *)
    printf 'Usage: %s {--now|--area|--active|--swappy}\n' "$0" >&2
    exit 2
    ;;
esac
