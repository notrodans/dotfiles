# ------------------------------------------------------------------------------
# Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
#
# Wave Theme
# ------------------------------------------------------------------------------

# Colors
background='#323f4e'
foreground='#f8f8f2'
color0='#3d4c5f'
color1='#f48fb1'
color2='#a1efd3'
color3='#f1fa8c'
color4='#92b6f4'
color5='#bd99ff'
color6='#87dfeb'
color7='#f8f8f2'
color8='#56687e' color9='#ee4f84'
color10='#53e2ae'
color11='#f1ff52'
color12='#6498ef'
color13='#985eff'
color14='#24d1e7'
color15='#e5e5e5'

accent='#BD99FF'
element_bg='#3D4C5F'
element_fg='#F8F8F8'

light_value='0.12'
dark_value='0.30'

# Wallpaper
wdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
wallpaper="$wdir/wallpaper" # Polybar
polybar_font='JetBrains Mono:size=10;3'

# Rofi
rofi_font='JetBrains Mono 10'
rofi_icon='Papirus-Apps'

# Terminal
# terminal_font_name='JetBrainsMono Nerd Font'
# terminal_font_size='10'

# Geany
geany_colors='wave.conf'
geany_font='JetBrains Mono 10'

# Appearance
gtk_theme='Juno-palenight'
icon_theme='Zafiro-icons'
cursor_theme='Vimix'

# Dunst
dunst_width='300'
dunst_height='80'
dunst_offset='20x58'
dunst_origin='bottom-right'
dunst_font='Iosevka Custom 9'
dunst_border='0'
dunst_separator='2'

# Picom
picom_backend='glx'
picom_corner='5'
picom_shadow_r='14'
picom_shadow_o='0.30'
picom_shadow_x='-12'
picom_shadow_y='-12'
picom_blur_method='dual_kawase'
picom_blur_strength='8'

# Bspwm
bspwm_fbc="$accent"
bspwm_nbc="$background"
bspwm_abc="$color5"
bspwm_pfc="$color2"
bspwm_border='0'
bspwm_gap='0'
bspwm_sratio='0.50'
