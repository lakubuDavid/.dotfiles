#!/bin/bash

# Get the current space index
current_space=$(yabai -m query --spaces --space | jq -r '.index')

# Get the total number of spaces
total_spaces=$(yabai -m query --spaces | jq -r '.[].index' | sort -n | tail -n1)

# Check if there is only one space, exit if true
if [ "$total_spaces" -eq 1 ]; then
    echo "Only one space left, cannot destroy it."
    exit 1
fi
# If the current space is not the last one focus on the next one
if [ "$current_space" -lt "$total_spaces" ]; then
    yabai -m space --focus $((current_space + 1))
else
    # Otherwise, focus on the previous space
    yabai -m space --focus $((current_space - 1))
fi

yabai -m space $current_space --destroy

