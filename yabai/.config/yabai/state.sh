#!/bin/bash

# Define the file to store the yabai state
YABAI_STATE_FILE="$HOME/.config/yabai/yabai_state.json"
# Save the current yabai state (spaces and windows)
save_yabai_state() {
    echo "Saving yabai state..."
    
    # Query spaces and windows and save to the file
    yabai -m query --spaces > "$YABAI_STATE_FILE"
    yabai -m query --windows >> "$YABAI_STATE_FILE"

    echo "Yabai state saved to $YABAI_STATE_FILE."
}

# Reload yabai state from the saved file
reload_yabai_state() {
    echo "Reloading yabai state..."

    if [[ -f "$YABAI_STATE_FILE" ]]; then
        # Read and restore spaces and window configurations (this may need to be customized based on your requirements)
        spaces=$(cat "$YABAI_STATE_FILE" | jq '.[] | select(.uuid)')
        windows=$(cat "$YABAI_STATE_FILE" | jq '.[] | select(.app)')

        # Apply saved space configurations (looping through each saved space)
        echo "$spaces" | jq -sc '.[]' | while read space; do
            index=$(echo "$space" | jq '.index')
            layout=$(echo "$space" | jq -r '.type')
            # yabai -m space --focus "$index"
            yabai -m space "$index" --layout "$layout"
        done

        # Apply saved window configurations (looping through each saved window)
        echo "$windows" | jq -sc '.[]' | while read window; do
            window_id=$(echo "$window" | jq '.id')
            app_name=$(echo "$window" | jq -r '.app')
            frame=$(echo "$window" | jq -r '.frame')
            size=$(echo "$window" | jq -r '"\(.frame.w | floor | tostring):\(.frame.h | floor | tostring)"')
            position=$(echo "$window" | jq -r '"\(.frame.x | floor | tostring):\(.frame.y | floor | tostring)"')
            yabai -m window "$window_id" --resize "abs:$size"
            yabai -m window "$window_id" --move "abs:$position"
        done

        echo "Yabai state restored from $YABAI_STATE_FILE."
    else
        echo "No saved state found. Skipping restore."
    fi
}

# Main function to handle saving and restoring
case "$1" in
    save)
        save_yabai_state
        ;;
    reload)
        reload_yabai_state
        ;;
    *)
        echo "Usage: $0 {save|reload}"
        exit 1
        ;;
esac

