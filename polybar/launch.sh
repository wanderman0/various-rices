#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar wanderman0 2>&1 | tee -a /tmp/polybar.log & disownp

echo "Polybar launched..."
