#!/usr/bin/env bash
set -euo pipefail

step=5

action=${1:-}

case "$action" in
  --get)
    volume=$(pamixer --get-volume)
    if ((volume == 0)); then
      printf 'Muted\n'
    else
      printf '%s%%\n' "$volume"
    fi
    ;;
  --inc)
    pamixer -u
    pamixer -i "$step"
    ;;
  --dec)
    pamixer -u
    pamixer -d "$step"
    ;;
  --toggle)
    pamixer -t
    ;;
  --toggle-mic)
    pamixer --default-source -t
    ;;
  --mic-inc)
    pamixer --default-source -u
    pamixer --default-source -i "$step"
    ;;
  --mic-dec)
    pamixer --default-source -u
    pamixer --default-source -d "$step"
    ;;
  *)
    printf 'Usage: %s {--get|--inc|--dec|--toggle|--toggle-mic|--mic-inc|--mic-dec}\n' "$0" >&2
    exit 2
    ;;
esac
