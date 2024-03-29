Here's the gist of what's going on:
https://endless.ersoft.org/pulseaudio-loopback/


Microphone -------------------------------------------> CombinedOutput ------> Discord Input (What they and only they hear)
                                                              ^
(Anything you want                                            |
them to hear, say --------------> ToBeRecorded --------------<o
a video game)                                                 |
                                                              |
                                                              V
(Everything else) --------------------------------------> Headphones (What you and only you hear)


In essence, we are creating sinks, or groups of audio sources, that'll be outputted through your headphones and Discord.
We have two groups: 
    - CombinedOutput, which is what'll be routed into Discord, so people in Discord (or whatever call) can hear
    - ToBeRecorded, which is what'll be routed into your headphones, and the above sink.

We need the two sinks so you don't have to hear yourself, 
and because while sinks and speakers can accept multiple sources, Discord can only accept one.
So may as well make it a sink... your mic PLUS your games!

## How to configure (goliveaudio2.sh, simpler way):

    - Edit the script and change the SPEAKERS and MIC variables to yours. When in doubt, use the lower numbers that don't have ".monitor" at the end. Make sure the full name is copied.
        - For a list of speakers: pactl list sinks short
        - For a list of mics: pactl list sources short

    - Run the script in the terminal. LEAVE IT RUNNING IN THE BACKGROUND. It will create two virtual sinks and three loopbacks; all will be configured automatically.
    - If you are already in a discord call, it will automatically configure and pick up the CombinedOutput sink. You can verify in the Recording tab in pavucontrol.
    - Go to the Playback tab and any applications you want to share should be set to ToBeRecorded.

## How to configure (goliveaudio.sh, older and more tedious way):

    - Run the script in the terminal. LEAVE IT RUNNING IN THE BACKGROUND. It will create two virtual sinks and three loopbacks where we can freely set inputs and outputs. 
      While a loopback can only have one input and one output, the virtual sinks allow us to reroute multiple loopbacks at a time.

    - Go into pavucontrol. On the Recording tab, you should see "WEBRTC VoiceEngine" (if you're in a Discord call), which is what Discord is listening to.
      Underneath are three loopbacks. They should all say "Loopback to CombinedOutput from." Let's set their inputs:
        - Set the first one to your microphone.
        - Set the other two to ToBeRecorded, the second sink.

    - Go back to the Playback tab. Find the three loopbacks there. Now we're gonna set their outputs... aka where they're gonna spit out their audio.
        - Set the one taking in your microphone to CombinedOutput.
        - Set the other two, taking input from ToBeRecorded, to CombinedOutput and your headphones/speakers respectively.
        - Any programs you want to record and share into Discord, should be set to ToBeRecorded.

    - Go back to the Recording tab. There should be two loopbacks into CombinedOutput and one into your headphones/speakers. 
      They should still be set to your microphone, ToBeRecorded, and ToBeRecorded respectively. Good good.
      
      Set WEBRTC VoiceEngine (Discord) to listen to audio from CombinedOutput. They should now be able to hear whatever apps you want them to hear, along with your mic.

      ***For a quick toggle, either individually set applications in Playback to your headphones/speakers, or in the Recording tab, set WEBRTC VoiceEngine to listen to your microphone rather than CombinedOutput.***



    - When you are done, hit enter on the running terminal window. It will ask for the "first number." pactl outputs the id numbers of modules into the console when
    they are created. Enter in the first number you see outputted, then the last one you see. The script will then loop from the first number to the last, deleting the respective modules.
    Everything should then be back to normal. If not, then set everything in the Playback tab to your headphones/speakers, and everything in the Recording tab to your microphone.


