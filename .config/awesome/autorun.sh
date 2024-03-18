#! /bin/sh

CONFIG_DIR="/home/notrodans/.config/awesome"

run() {
	if !pgrep -f "$1";
	then
		"$@"&
	fi
}

nvidia-settings --load-config-only 
xset r rate 300 50
xinput set-prop 'Kingston HyperX Pulsefire FPS Pro' 'libinput Accel Speed' -1
xsetroot -cursor_name left_ptr
