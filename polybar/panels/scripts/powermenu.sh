#!/usr/bin/env bash

# Check if rofi is already running and kill it if it is
if pgrep -x "rofi" > /dev/null; then
    killall rofi
    exit 0
fi

DIR="$HOME/.config/polybar/panels/menu"
uptime=$(uptime -p | sed -e 's/up //g')

# Directly set theme to "gnome"
theme="gnome"

# Using correct rofi syntax for key bindings
rofi_command="rofi -no-config -theme $DIR/$theme/powermenu.rasi -kb-cancel Escape,Super_L+x"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Confirmation
confirm_exit() {
    rofi -dmenu\
        -no-config\
        -i\
        -no-fixed-num-lines\
        -p "Are You Sure? : "\
        -theme $DIR/$theme/confirm.rasi\
        -kb-cancel Escape,Super_L+x
}

# Message
msg() {
    rofi -no-config -theme "$DIR/$theme/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            systemctl poweroff
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $reboot)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            systemctl reboot
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $lock)
        if [[ -f /usr/bin/i3lock ]]; then
            i3lock
        elif [[ -f /usr/bin/betterlockscreen ]]; then
            betterlockscreen -l
        fi
        ;;
    $suspend)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $logout)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
                openbox --exit
            elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
                bspc quit
            elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
                i3-msg exit
            fi
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
esac