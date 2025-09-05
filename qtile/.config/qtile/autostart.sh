#!/usr/bin/env bash

COLORSCHEME=tomorrow-night

### AUTOSTART PROGRAMS ###
killall picom

# Start Picom with the config file in the background
picom --config ~/.config/picom/picom.conf --daemon &
xrandr --output DisplayPort-0 --mode 3440x1440 --rate 165 &
lxsession &

dunst &

nm-applet &
systemctl --user start mpd &
"$HOME"/.screenlayout/layout.sh &
sleep 1
conky -c "$HOME"/.config/conky/qtile/01/"$COLORSCHEME".conf || echo "Couldn't start conky."

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
# xargs xwallpaper --stretch <~/.cache/wall &
# 2. Uncomment to set a random wallpaper on login
# find /usr/share/backgrounds/dtos-backgrounds/ -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
nitrogen --restore &

if [ ! -d "$HOME"/.cache/betterlockscreen/ ]; then
  betterlockscreen -u /usr/share/backgrounds/dtos-backgrounds/0277.jpg &
fi
gnome-keyring-daemon --start --components=secrets &
