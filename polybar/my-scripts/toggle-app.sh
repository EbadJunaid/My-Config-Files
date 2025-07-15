#!/bin/bash

# Usage: ./toggle-app.sh <application_name>
# Example: ./toggle-app.sh pavucontrol

if [ $# -eq 0 ]; then
    echo "Usage: $0 <application_name>"
    exit 1
fi

APP_NAME="$1"

# Check if the application is running
if pgrep -x "$APP_NAME" > /dev/null; then
    # If running, kill it
    pkill -x "$APP_NAME"
else
    # If not running, start it
    "$APP_NAME" &
fi