#!/bin/bash

# Testing stuff with searching for discord stuff
SPEAKERS="alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo.monitor"
MIC="alsa_input.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-mono"

# Apparently (idk if this is true for other systems) Discord is the one source-output that has a single channel @ 44100Hz. Hmmmm...
# There's a more thorough way but this makes it extremely easy to get the id
discordID=$(pactl list source-outputs short | grep "s16le 1ch 44100Hz" | cut -f1)

# do the thing
pactl move-source-output $discordID $SPEAKERS
