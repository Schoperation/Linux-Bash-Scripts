#!/bin/bash

# Kill discord twice to ensure we get all discord
pkill Discord
sleep 0.5s
pkill Discord

# Clear tmp folder of discord-infested stuff
rm -r /tmp/.org.chromium.Chromium.*
# flatpak edition command
#nohup /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=discord com.discordapp.Discord &>/dev/null &

# normal
nohup discord &>/dev/null &
sleep 7s

# manipulate discord window
wmctrl -r Friends -e 0,1920,0,1920,1060
#sleep 0.5s
#wmctrl -r Discord -b toggle,maximized_vert,maximized_horz


