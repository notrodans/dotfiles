#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
##
## Script to take screenshots on Archcraft.

# file
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

# directory
if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		sleep 1
	done
}

# take shots
shotnow () {
	cd ${dir} && maim -u -f png | copy_shot
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && maim -u -f png | copy_shot
}

shot10 () {
	countdown '10'
	sleep 1 && cd ${dir} && maim -u -f png | copy_shot
}

shotwin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` | copy_shot
}

shotarea () {
	cd ${dir} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
}

# execute
if [[ "$1" == "--now" ]]; then
	shotnow
elif [[ "$1" == "--in5" ]]; then
	shot5
elif [[ "$1" == "--in10" ]]; then
	shot10
elif [[ "$1" == "--win" ]]; then
	shotwin
elif [[ "$1" == "--area" ]]; then
	shotarea
else
	echo -e "Available Options : --now --in5 --in10 --win --area"
fi

exit 0
