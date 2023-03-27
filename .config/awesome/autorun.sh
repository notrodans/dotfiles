#!/bin/sh

CONFIG_DIR="/home/notrodans/.config/awesome"

run() {
	if !pgrep -f "$1";
	then
		"$@"&
	fi
}

nvidia-settings --load-config-only
xset r rate 350 60
xinput set-prop 'Kingston HyperX Pulsefire FPS Pro' 'libinput Accel Speed' -0.9
xsetroot -cursor_name left_ptr
bash `$CONFIG_DIR/scripts/picom-toggle.sh`
