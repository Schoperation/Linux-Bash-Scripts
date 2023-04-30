#!/bin/bash

# Kill discord twice to ensure we get all discord
pkill Discord
sleep 0.5s
pkill Discord

# Clear tmp folder of discord-infested stuff
rm -r /tmp/.org.chromium.Chromium.*

nohup discord &>/dev/null &


