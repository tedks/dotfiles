#!/bin/bash

while true; do
    if [ $(pidof nm-applet) ]; then
	echo "`date`: nm-applet up"
	sleep 300
    else
	echo "`date`: **** nm-applet down ****"
	nm-applet &
    fi
done
