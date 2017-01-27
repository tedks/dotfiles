#!/bin/bash -x

while true; do
    ping -c 4 4.2.2.1 > /dev/null 2>&1
    if ping -c 4 4.2.2.1 > /dev/null 2>&1; then
	echo "`date`: network up!" && sleep 300
    else
	killall nm-applet
	disown nm-applet >/dev/null 2>&1 
    fi;
done
