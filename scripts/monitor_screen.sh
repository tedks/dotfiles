#!/bin/bash

## Launch a GNU Screen session with windows set to monitor.

# Check if one exists, and if so, attach to it.
if screen -ls | grep monitor
then
    screen -xS monitor; exit $?;
fi

# Launch a Screen session using Byobu to get its status bar
# -d -m launches in "detatched mode"
byobu -d -m -S monitor -t atop atop
screen -S monitor -X screen -t net monitor_network
screen -S monitor -X screen -t nm-app keep_nm_applet_alive
screen -S monitor -X screen -t ping ping 4.2.2.1
screen -S monitor -X screen -t sun ssh sunbringer bash top
# launch the screen
screen -xS monitor; exit $?
