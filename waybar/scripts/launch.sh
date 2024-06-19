#!/bin/bash
# Check if waybar-disabled file exists
if [ -f $HOME/.cache/waybar-disabled ] ;then 
    killall waybar
    pkill waybar
    exit 1 
fi

# ----------------------------------------------------- 
# Quit all running waybar instances
# ----------------------------------------------------- 
killall waybar
pkill waybar
sleep 0.2

# ----------------------------------------------------- 
# Default theme: /THEMEFOLDER;/VARIATION
# ----------------------------------------------------- 
themestyle="/Top;/Top/light"

# ----------------------------------------------------- 
# Get current theme information from .cache/.themestyle.sh
# ----------------------------------------------------- 
if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi

IFS=';' read -ra arrThemes <<< "$themestyle"
echo "Theme: ${arrThemes[0]}"

# if [ ! -f ~/.config/waybar/themes${arrThemes[1]}/style.css ]; then
#     themestyle="/ml4w;/ml4w/light"
# fi


waybar -c ~/.config/waybar/themes${arrThemes[0]}/config -s ~/.config/waybar/themes${arrThemes[1]}/style.css &
