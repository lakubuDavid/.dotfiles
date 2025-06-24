#!/usr/bin/env bash

# query the focused window's frame
frame=$(yabai -m query --windows --window)

w=$(echo $frame | jq '.frame.w')
h=$(echo $frame | jq '.frame.h')

# if either dimension is below threshold, toggle float ON
if (( w < FLOAT_WIDTH )) || (( h < FLOAT_HEIGHT )); then
  yabai -m window --toggle float
fi

