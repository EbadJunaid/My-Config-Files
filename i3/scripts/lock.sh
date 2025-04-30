#!/bin/bash
# Define colors
BG='#00000000'
TXT='#ffffff'
WRONG='#ff0000'
VERIFY='#00ff00'

# When locking, set screen blanking to 20 seconds
xset dpms 20 20 20

# Lock the screen
i3lock \
    -i /home/ebad/Pictures/Wallpapers/peakpx.jpg \
    --scale \
    --clock \
    --indicator \
    --time-color=$TXT \
    --date-color=$TXT \
    --time-str="%I:%M:%S %p" \
    --date-str="%A %B %d %Y" \
    --verif-color=$VERIFY \
    --wrong-color=$WRONG \
    --modif-color=$TXT \
    --layout-color=$TXT \
    --ring-color=$TXT \
    --line-color=$BG \
    --separator-color=$BG \
    --keyhl-color=$VERIFY \
    --bshl-color=$WRONG \
    --radius=120 \
    --noinput-text="No Input" \
    --wrong-text="Wrong!" \
    --verif-text="Verifying..." \
    --show-failed-attempts \
    --ignore-empty-password \
    -f # Add forking option

# Sleep for a moment to ensure i3lock has started
sleep 1

#Adding for more sleep just for the lock-screen apprears for x seconds

sleep 19

# Force DPMS timeout immediately
xset dpms force off

# After unlocking, reset DPMS to 10 minutes for inactivity
xset dpms 600 600 600