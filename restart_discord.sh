#!/bin/bash

# Kill discord twice to ensure we get all discord
pkill Discord
sleep 0.5s
pkill Discord

# Clear tmp folder of discord-infested stuff
rm -r /tmp/.org.chromium.Chromium.*
#nohup /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=discord com.discordapp.Discord &>/dev/null &
nohup discord &>/dev/null &
sleep 5s

# manipulate discord window
wmctrl -r Discord -e 0,1920,0,1920,1060
#sleep 0.5s
#wmctrl -r Discord -b toggle,maximized_vert,maximized_horz


