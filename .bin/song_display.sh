#!/usr/bin/env bash

# Description: Display cover for the current playing song using notify-send

# Get current album name
album=$(mpc -f %album% current)

image_dir="Pictures/cover.jpg"

# Get cover image name
cover=`ls -1 ~/"$image_dir" | grep -E 'Cover.jpg|Cover.jpeg'`

# Get path to cover image
image="$image_dir/$cover"

# Send notify and store its ID in $notify_ID
notify_ID=$(notify-send.sh -p -i ~/"$image" \
    "$(mpc current -f %album%)" \
    "$(mpc current -f %title%)")

# Waiting for 2 seconds
sleep 2s

# Delete notify using its ID
# notify-send.sh --close=$notify_ID
