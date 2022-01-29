#!/bin/bash
#pactl load-module module-null-sink sink_name=Virtual1
#pactl load-module module-loopback source=alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo.monitor sink=Virtual1
#pactl load-module module-loopback source=Virtual1.monitor sink=alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo

#pactl load-module module-combine-sink sink_name=nullandmain slaves=alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo,Virtual1



# alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo.monitor       source #1
# alsa_output.usb-Corsair_Corsair_VOID_PRO_Wireless_Gaming_Headset-00.analog-stereo               sink #1



pactl load-module module-null-sink sink_name=First sink_properties=device.description=CombinedOutput
pactl load-module module-null-sink sink_name=Second sink_properties=device.description=ToBeRecorded
pactl load-module module-loopback sink=First
pactl load-module module-loopback sink=First
pactl load-module module-loopback sink=First

# pause before deleting
read -rsp $'Press enter to continue...\n'

# ask for module numbers
read -p 'First number: ' firstNum
read -p 'Last number: ' lastNum
for i in $(seq $firstNum $lastNum); do pactl unload-module $i; done

# pactl unload-module [num]


