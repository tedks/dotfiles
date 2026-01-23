#!/bin/bash

ffmpeg -i "${1}" -vf subtitles="${2}" -acodec copy subbed-"${1}"

