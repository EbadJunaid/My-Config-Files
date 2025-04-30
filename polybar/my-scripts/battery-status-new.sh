#!/bin/bash

# Define icons
ICONS=("" "" "" "" "" "" "" "" "" "")

# Define sound files
PLUGGED_IN_SOUND="/usr/share/sounds/Yaru/stereo/power-plug.oga"
PLUGGED_OUT_SOUND="/usr/share/sounds/Yaru/stereo/power-unplug.oga"

# Define status file paths
PLUGGED_IN_STATUS_FILE="/home/ebad/.config/polybar/my-scripts/plugged-in-sound-status.txt"
PLUGGED_OUT_STATUS_FILE="/home/ebad/.config/polybar/my-scripts/plugged-out-sound-status.txt"
LOW_BATTERY_STATUS_FILE="/home/ebad/.config/polybar/my-scripts/low-battery-status.txt"

# Check if the status files exist, if not, create them and initialize them
if [ ! -f "$PLUGGED_IN_STATUS_FILE" ]; then
    echo "notplayed" > "$PLUGGED_IN_STATUS_FILE"
fi

if [ ! -f "$PLUGGED_OUT_STATUS_FILE" ]; then
    echo "notplayed" > "$PLUGGED_OUT_STATUS_FILE"
fi

if [ ! -f "$LOW_BATTERY_STATUS_FILE" ]; then
    echo "notsend" > "$LOW_BATTERY_STATUS_FILE"
fi

# Get current battery status (Charging or Discharging) and capacity
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Determine icon index based on capacity
INDEX=$((CAPACITY / 10))
[ $INDEX -gt 9 ] && INDEX=9

# Read the current status from the files
PLUGGED_IN_STATUS=$(cat "$PLUGGED_IN_STATUS_FILE")
PLUGGED_OUT_STATUS=$(cat "$PLUGGED_OUT_STATUS_FILE")
LOW_BATTERY_STATUS=$(cat "$LOW_BATTERY_STATUS_FILE")

# Logic for Charging (plugged in)
if [ "$STATUS" == "Charging" ] || [ "$STATUS" == "Full" ]; then
    COLOR="%{F#00FF00}"  # Green
    if [ "$PLUGGED_IN_STATUS" == "notplayed" ]; then
        # Play charging sound
        paplay "$PLUGGED_IN_SOUND"
        # Update status files
        echo "played" > "$PLUGGED_IN_STATUS_FILE"
        echo "notplayed" > "$PLUGGED_OUT_STATUS_FILE"
    fi

    # Reset low battery notification status when charging
    echo "notsend" > "$LOW_BATTERY_STATUS_FILE"

# Logic for Discharging (plugged out)
else
    COLOR="%{F#FFFFFF}"  # White
    if [ "$PLUGGED_OUT_STATUS" == "notplayed" ]; then
        # Play discharging sound
        paplay "$PLUGGED_OUT_SOUND"
        # Update status files
        echo "played" > "$PLUGGED_OUT_STATUS_FILE"
        echo "notplayed" > "$PLUGGED_IN_STATUS_FILE"
    fi

    # Check for low battery and send notification
    if [ "$CAPACITY" -le 20 ] && [ "$LOW_BATTERY_STATUS" == "notsend" ]; then
        notify-send "Low Battery" "${CAPACITY}% battery remaining!" -u critical -i "low-battery-alert"
        echo "send" > "$LOW_BATTERY_STATUS_FILE"
    fi
fi

echo "${COLOR}${ICONS[$INDEX]}  %{F-}${CAPACITY}%"
