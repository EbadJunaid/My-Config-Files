#!/bin/sh

# Adjust screen brightness using brightnessctl and send a notification
# displaying the current brightness level.

send_notification() {
    # Get the current brightness level
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    brightness_percent=$((brightness * 100 / max_brightness))
    dunstify -a "changebrightness" -u low -r 9991 -h int:value:"$brightness_percent" -i "brightness" "$brightness_percent%" -t 2000
}

case $1 in
up)
    # Increase brightness by 3%
    brightnessctl -q set 3%+
    send_notification "$1"
    ;;
down)
    # Decrease brightness by 3% (with a minimum value of 2)
    brightnessctl --min-val=2 -q set 3%-
    send_notification "$1"
    ;;
*)
    echo "Usage: $0 {up|down}"
    exit 1
    ;;
esac
