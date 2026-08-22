#!/bin/bash
# Convertit la sortie ascii brute de cava en barres unicode, ligne par ligne,
# pour un module "custom" de Waybar (tail: true).

bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
config="$HOME/.config/cava/waybar.conf"

cava -p "$config" | while IFS=";" read -ra values; do
    output=""
    for v in "${values[@]}"; do
        [ -z "$v" ] && continue
        output+="${bars[$v]}"
    done
    echo "$output"
done
