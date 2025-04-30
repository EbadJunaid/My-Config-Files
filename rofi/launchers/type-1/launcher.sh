#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    killall rofi
    exit 0
fi

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-7'

## Run with modified key bindings
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi \
    -kb-cancel Escape,Super_L+d