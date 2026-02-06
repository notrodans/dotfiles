#!/bin/bash
# A bash script designed to run only once dotfiles installed

# Variables
coreScripts=$HOME/.config/hypr/core/scripts
wallpaper=$HOME/Pictures/wallpapers/Fantasy-Landscape.png
waybar_style="$HOME/.config/waybar/style/Retro.css"

swww="swww img"

# Check if a marker file exists.
if [ ! -f ~/.config/hypr/.initial_startup_done ]; then

    # Initialize pywal and wallpaper
	if [ -f "$wallpaper" ]; then
		swww init && $swww $wallpaper
	    "$coreScripts/PywalSwww.sh" > /dev/null 2>&1 & 
	fi
     
    # Initial waybar style
	if [ -f "$waybar_style" ]; then
    	ln -sf "$waybar_style" "$HOME/.config/waybar/style.css"
	fi

    # Create a marker file to indicate that the script has been executed.
    touch ~/.config/hypr/.initial_startup_done

    exit
fi
