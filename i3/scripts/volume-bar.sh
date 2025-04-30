#!/bin/sh

# Increment, decrement, or mute the volume and send a notification
# of the current volume level.

send_notification() {
    # Get the current volume level
    volume=$(pulsemixer --get-volume | awk '{print $1}')
    dunstify -a "changevolume" -u low -r 9993 -h int:value:"$volume" -i "volume" "${volume}%" -t 2000
}

case $1 in
up)
    # Increase the volume by 5%
    pulsemixer --change-volume +5 --max-volume 100
    send_notification "$1"
    ;;
down)
    # Decrease the volume by 5%
    pulsemixer --change-volume -5
    send_notification "$1"
    ;;
mute)
    # Toggle mute
    pulsemixer --toggle-mute
    if pulsemixer --get-mute | grep -q "1"; then
        dunstify -a "changevolume" -t 2000 -r 9993 -u low -i "volume-mute" "Muted"
    else
        send_notification up
    fi
    ;;
*)
    echo "Usage: $0 {up|down|mute}"
    exit 1
    ;;
esac
