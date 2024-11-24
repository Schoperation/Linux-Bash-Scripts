#!/bin/bash

# Thanks to this guy https://github.com/toadjaune/pulseaudio-config
# Provided a very helpful template to make this script way better

# Setting speakers and microphone
pactl list sinks short
read -rp "Enter the ID of your speakers: " SPEAKERS_NUM
echo
TAB=$'\t'
SPEAKERS=$(pactl list sinks short | grep "$SPEAKERS_NUM$TAB" | cut -f2)

pactl list sources short
read -rp "Enter the ID of your microphone: " MIC_NUM
echo
MIC=$(pactl list sources short | grep "$MIC_NUM$TAB" | cut -f2)

MODULE_INDICES=(0)

# Create null sinks
MODULE_INDICES[0]=$(pactl load-module module-null-sink sink_name=Combined sink_properties=device.description="CombinedOutput")
MODULE_INDICES[1]=$(pactl load-module module-null-sink sink_name=TBR sink_properties=device.description="ToBeRecorded")

# Create and set loopbacks                              Recording Tab  Playback
MODULE_INDICES[2]=$(pactl load-module module-loopback sink=Combined source=$MIC source_output_properties=media.name=Mic-To-Combined)
MODULE_INDICES[3]=$(pactl load-module module-loopback sink=Combined source=TBR.monitor source_output_properties=media.name=Their-Game-Volume)
MODULE_INDICES[4]=$(pactl load-module module-loopback sink=$SPEAKERS source=TBR.monitor source_output_properties=media.name=Your-Game-Volume)

echo -n "The module indices are: "
for i in ${MODULE_INDICES[@]}; do echo -n "$i, "; done

echo
# Find the ID of the Discord source output. It's (assumably) the only one with a single channel, 44100Hz, s16le...
discordID=$(pactl list source-outputs short | grep "protocol-native.c" | grep "s16le 1ch 44100Hz" | cut -f1)
pactl move-source-output $discordID Combined.monitor

# Launch pavucontrol with instructions
echo -ne "\n~~~ Now sharing! ~~~\n"
echo -e "Set any applications in the Playback tab to \"ToBeRecorded\" to share audio!"
echo "It is recommended to turn OFF noise suppression, especially for video games."
echo -e "You can adjust the game volume for THEM by going to the Recording tab and adjusting \"Their-Game-Volume.\"\n"
pavucontrol &>/dev/null &

# Pause before deleting
read -rsp "Press Enter to stop sharing..."

# Switch discord back to solely the microphone
pactl move-source-output $discordID $MIC

echo -e "\nDeleting modules..."
for i in ${MODULE_INDICES[@]}; do pactl unload-module $i; done
