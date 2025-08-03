#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"

menu(){
  printf "1. view Env-variables\n"
  printf "2. view Window-Rules\n"
  printf "3. view Startup_Apps\n"
  printf "4. view User-Keybinds\n"
  printf "5. view Monitors\n"
  printf "6. view Laptop-Keybinds\n"
  printf "7. view User-Settings\n"
  printf "8. view Default-Settings\n"
  printf "9. view Default-Keybinds\n"
}

main() {
    choice=$(menu | rofi -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            kitty -e $EDITOR "$UserConfigs/ENVariables.conf"
            ;;
        2)
            kitty -e $EDITOR "$UserConfigs/WindowRules.conf"
            ;;
        3)
            kitty -e $EDITOR "$UserConfigs/Startup_Apps.conf"
            ;;
        4)
            kitty -e $EDITOR "$UserConfigs/UserKeybinds.conf"
            ;;
        5)
            kitty -e $EDITOR "$UserConfigs/Monitors.conf"
            ;;
        6)
            kitty -e $EDITOR "$UserConfigs/Laptops.conf"
            ;;
        7)
            kitty -e $EDITOR "$UserConfigs/UserSettings.conf"
            ;;
        8)
            kitty -e $EDITOR "$configs/Settings.conf"
            ;;
        9)
            kitty -e $EDITOR "$configs/Keybinds.conf"
            ;;
        *)
            ;;
    esac
}

main
