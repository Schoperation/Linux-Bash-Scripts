#!/bin/bash

# Thanks to this guy https://github.com/toadjaune/pulseaudio-config
# Provided a very helpful template to make this script way better

# Set speaker and microphone variables
SPEAKERS="alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo"
MIC="alsa_input.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-mono"

# Used to store the indices of the modules created
NUM=0
INDICES=(0)

# Create null sinks
INDICES[0]=$(pactl load-module module-null-sink sink_name=Combined sink_properties=device.description="CombinedOutput")
INDICES[1]=$(pactl load-module module-null-sink sink_name=TBR sink_properties=device.description="ToBeRecorded")

# Create and set loopbacks                      Recording Tab  Playback
INDICES[2]=$(pactl load-module module-loopback sink=Combined source=$MIC)
INDICES[3]=$(pactl load-module module-loopback sink=Combined source=TBR.monitor)
INDICES[4]=$(pactl load-module module-loopback sink=$SPEAKERS source=TBR.monitor)

echo -n "The indices are: "
for i in ${INDICES[@]}; do echo -n "$i, "; done

# Find the ID of the Discord source output. It's (assumbly) the only one with a single channel, 44100Hz, s16le...
discordID=$(pactl list source-outputs short | grep "s16le 1ch 44100Hz" | cut -f1)
pactl move-source-output $discordID Combined.monitor

# Launch pavucontrol with instructions
echo -e "\n\nSet any applications in the Playback tab to \"ToBeRecorded\" to share audio!"
echo -e "You can adjust the game volume for THEM by going to the Recording tab and adjusting the \"Loopback to CombinedOutput from Monitor of ToBeRecorded\". Usually the second loopback.\n"
pavucontrol &>/dev/null &

# Pause before deleting
read -rsp $"Done. Press enter to end sharing..."

# Switch discord back to solely the microphone
pactl move-source-output $discordID $MIC

echo -e "\nDeleting modules..."
for i in ${INDICES[@]}; do pactl unload-module $i; done
