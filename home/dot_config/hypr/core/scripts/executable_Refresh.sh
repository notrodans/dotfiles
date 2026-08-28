#!/usr/bin/env bash
set -euo pipefail

if [[ -d /run/systemd/system ]]; then
    systemctl --user restart waybar.service
fi

hyprctl reload
