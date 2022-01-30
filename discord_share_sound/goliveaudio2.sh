#!/bin/bash

# Thanks to this guy https://github.com/toadjaune/pulseaudio-config
# Provided a very helpful template to make this script way better

# UNFINISHED... works but not the best way

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

# Launch pavucontrol with instructions
echo -e "\nSet any applications to \"ToBeRecorded\" to share audio in the Playback tab, then in the Recording tab, set Discord (WEBRTC VoiceEngine) to \"CombinedOutput\"."
echo -e "You can adjust the game volume for THEM by going to the Recording tab and adjusting the \"Loopback to CombinedOutput from Monitor of ToBeRecorded\". Usually the second loopback."
pavucontrol &>/dev/null &

# Pause before deleting
read -rsp $"Press enter to continue..."

echo -e "\nDeleting..."
for i in ${INDICES[@]}; do pactl unload-module $i; done
