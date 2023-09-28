#! /bin/bash

source "$HOME/.cache/wal/colors.sh"

background=${background:1}
color1=${color1:1}

hyprctl keyword general:col.active_border "rgb($background) rgb($color1) 0deg"
