#!/bin/bash

# Audio output detection script for polybar
# State file to store previous information
STATE_FILE="$HOME/.config/polybar/my-scripts/audio-icons-save.txt"

get_audio_output() {
    # Get all sinks information
    local sinks_info=$(pactl list sinks)
    
    # Variables to track current running sink
    local running_sink_id=""
    local running_sink_name=""
    local running_active_port=""
    local current_sink_id=""
    local current_sink_name=""
    local current_state=""
    local current_port=""
    
    # Parse through all sinks to find the running one
    while IFS= read -r line; do
        if [[ $line =~ ^Sink\ #([0-9]+) ]]; then
            current_sink_id="${BASH_REMATCH[1]}"
            current_sink_name=""
            current_state=""
            current_port=""
        elif [[ $line =~ ^[[:space:]]*Name:\ (.+) ]]; then
            current_sink_name="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^[[:space:]]*State:\ (.+) ]]; then
            current_state="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^[[:space:]]*Active\ Port:\ (.+) ]]; then
            current_port="${BASH_REMATCH[1]}"
            
            # If we found a running sink, store its details
            if [[ "$current_state" == "RUNNING" ]]; then
                running_sink_id="$current_sink_id"
                running_sink_name="$current_sink_name"
                running_active_port="$current_port"
                break
            fi
        fi
    done <<< "$sinks_info"
    
    # Check if we found a running sink
    if [[ -n "$running_sink_id" ]]; then
        # Save current state to file
        echo "SINK_ID=$running_sink_id" > "$STATE_FILE"
        echo "SINK_NAME=$running_sink_name" >> "$STATE_FILE"
        echo "ACTIVE_PORT=$running_active_port" >> "$STATE_FILE"
        
        # Determine icon based on running sink
        local icon=""
        
        # First check if sink name contains bluetooth indicators
        if echo "$running_sink_name" | grep -qi "bluez\|bluetooth"; then
            icon="󰂯"  # Bluetooth icon
        else
            # Check active port for wired devices
            case "$running_active_port" in
                *headphone*|*headset*)
                    icon="󰋋"  # Wired headphones icon
                    ;;
                *speaker*)
                    icon="📢"  # Speaker icon
                    ;;
                *)
                    icon="📢"  # Default to speaker
                    ;;
            esac
        fi
        
        echo "$icon"
        return
    fi
    
    # No running sink found - check previous state
    if [[ -f "$STATE_FILE" ]]; then
        # Read previous state
        local prev_sink_id=""
        local prev_sink_name=""
        local prev_active_port=""
        
        while IFS= read -r line; do
            if [[ $line =~ ^SINK_ID=(.+) ]]; then
                prev_sink_id="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^SINK_NAME=(.+) ]]; then
                prev_sink_name="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^ACTIVE_PORT=(.+) ]]; then
                prev_active_port="${BASH_REMATCH[1]}"
            fi
        done < "$STATE_FILE"
        
        # Get current default sink
        local default_sink=$(pactl get-default-sink)
        
        # Find current info about the previous sink
        local current_sink_info=""
        local current_active_port=""
        local found_sink=false
        
        while IFS= read -r line; do
            if [[ $line =~ ^Sink\ #([0-9]+) ]]; then
                if [[ "${BASH_REMATCH[1]}" == "$prev_sink_id" ]]; then
                    found_sink=true
                else
                    found_sink=false
                fi
            elif [[ $line =~ ^[[:space:]]*Name:\ (.+) ]] && [[ "$found_sink" == true ]]; then
                if [[ "${BASH_REMATCH[1]}" == "$prev_sink_name" ]]; then
                    # This is our previous sink, continue reading
                    continue
                else
                    found_sink=false
                fi
            elif [[ $line =~ ^[[:space:]]*Active\ Port:\ (.+) ]] && [[ "$found_sink" == true ]]; then
                current_active_port="${BASH_REMATCH[1]}"
                break
            fi
        done <<< "$sinks_info"
        
        # Check if previous sink name matches default sink
        if [[ "$prev_sink_name" == "$default_sink" ]]; then
            # Previous sink is still default, check if active port changed
            if [[ "$current_active_port" != "$prev_active_port" ]]; then
                # Update the state file with new active port
                echo "SINK_ID=$prev_sink_id" > "$STATE_FILE"
                echo "SINK_NAME=$prev_sink_name" >> "$STATE_FILE"
                echo "ACTIVE_PORT=$current_active_port" >> "$STATE_FILE"
                
                # Determine new icon based on current active port
                local icon=""
                
                # Check if previous sink was bluetooth
                if echo "$prev_sink_name" | grep -qi "bluez\|bluetooth"; then
                    icon="󰂯"  # Bluetooth icon
                else
                    # Check current active port
                    case "$current_active_port" in
                        *headphone*|*headset*)
                            icon="󰋋"  # Wired headphones icon
                            ;;
                        *speaker*)
                            icon="📢"  # Speaker icon
                            ;;
                        *)
                            icon="📢"  # Default to speaker
                            ;;
                    esac
                fi
                
                echo "$icon"
            else
                # Active port hasn't changed, return icon based on previous state
                local icon=""
                
                # Check if previous sink was bluetooth
                if echo "$prev_sink_name" | grep -qi "bluez\|bluetooth"; then
                    icon="󰂯"  # Bluetooth icon
                else
                    # Check previous active port
                    case "$prev_active_port" in
                        *headphone*|*headset*)
                            icon="󰋋"  # Wired headphones icon
                            ;;
                        *speaker*)
                            icon="📢"  # Speaker icon
                            ;;
                        *)
                            icon="📢"  # Default to speaker
                            ;;
                    esac
                fi
                
                echo "$icon"
            fi
        else
            # Previous sink is not default anymore, check default sink
            if echo "$default_sink" | grep -qi "bluez\|bluetooth"; then
                # Default sink is bluetooth
                echo "󰂯"  # Bluetooth icon
            else
                # Find default sink's active port
                local default_active_port=""
                local default_sink_id=""
                local found_default=false
                
                while IFS= read -r line; do
                    if [[ $line =~ ^Sink\ #([0-9]+) ]]; then
                        current_sink_id="${BASH_REMATCH[1]}"
                        found_default=false
                    elif [[ $line =~ ^[[:space:]]*Name:\ (.+) ]]; then
                        if [[ "${BASH_REMATCH[1]}" == "$default_sink" ]]; then
                            found_default=true
                            default_sink_id="$current_sink_id"
                        fi
                    elif [[ $line =~ ^[[:space:]]*Active\ Port:\ (.+) ]] && [[ "$found_default" == true ]]; then
                        default_active_port="${BASH_REMATCH[1]}"
                        break
                    fi
                done <<< "$sinks_info"
                
                # Update state file with new default sink info
                echo "SINK_ID=$default_sink_id" > "$STATE_FILE"
                echo "SINK_NAME=$default_sink" >> "$STATE_FILE"
                echo "ACTIVE_PORT=$default_active_port" >> "$STATE_FILE"
                
                # Determine icon based on default sink's active port
                local icon=""
                case "$default_active_port" in
                    *headphone*|*headset*)
                        icon="󰋋"  # Wired headphones icon
                        ;;
                    *speaker*)
                        icon="📢"  # Speaker icon
                        ;;
                    *)
                        icon="📢"  # Default to speaker
                        ;;
                esac
                
                echo "$icon"
            fi
        fi
    else
        # No previous state file, return default
        echo "󰖁"  # Muted icon
    fi
}

# Debug function to show current state
debug_info() {
    echo "=== Current Sinks ==="
    pactl list sinks | grep -E "(Sink #|Name:|State:|Active Port:)"
    echo ""
    echo "=== Saved State ==="
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "No saved state"
    fi
    echo ""
    echo "=== Current Icon ==="
    get_audio_output
}

# Main execution
case "${1:-}" in
    --click)
        pavucontrol &
        ;;
    --debug)
        debug_info
        ;;
    --reset)
        rm -f "$STATE_FILE"
        echo "State file reset"
        ;;
    *)
        get_audio_output
        ;;
esac