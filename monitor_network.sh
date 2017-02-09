#!/bin/bash
HOST=4.2.2.1

while sleep 30; do
    ping -c 4 "${HOST}" > /dev/null 2>&1
    if ping -c 4 "${HOST}" > /dev/null 2>&1; then
	echo "`date`: network up!"
    else
	killall nm-applet
	disown nm-applet >/dev/null 2>&1
    fi;
done
