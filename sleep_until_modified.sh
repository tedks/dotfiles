#!/bin/bash

# this is not originally mine, but I have lost the original source.
# Everything but the linebreak and --recursive in the call to
# inotifywait are from the original author; hopefully google will find
# them in time.

SCRIPTNAME=`basename "$0"`

print_help() {
	cat << EOF
Usage: $SCRIPTNAME filename
Uses 'inotifywait' to sleep until 'filename' has been modified.
EOF
}


# parse_parameters:
while [[ "$1" == -* ]] ; do
	case "$1" in
		-h|-help|--help)
			print_help
			exit
			;;
		--)
			#echo "-- found"
			shift
			break
			;;
		*)
			echo "Invalid parameter: '$1'"
			exit 1
			;;
	esac
done

inotifywait --event modify --recursive --quiet $@ 2>&1 >/dev/null

