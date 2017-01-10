#!/bin/bash

while true; do
    ping -c 4 4.2.2.1 > /dev/null 2>&1
    if [ $? ]; then
	(echo "`date`: network up!" && sleep 300)
    else
	killall nm-applet;
    fi;
done
