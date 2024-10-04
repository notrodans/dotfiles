#! /bin/sh

CONFIG_DIR="/home/notrodans/.config/awesome"

run() {
	if !pgrep -f "$1";
	then
		"$@"&
	fi
}

picom -b --config $CONFIG_DIR/picom.conf
xrandr --output HDMI-1 --mode 1680x1050 --rate 75
wal -R -s -n
vibrant-cli HDMI-1 1.75
xgamma -gamma 1.09
# nvidia-settings --load-config-only 
xset r rate 300 50
xinput set-prop 'Kingston HyperX Pulsefire FPS Pro' 'libinput Accel Speed' -1
xsetroot -cursor_name left_ptr
