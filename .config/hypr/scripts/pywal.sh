#! /bin/bash

source "$HOME/.cache/wal/colors.sh"

background=${background:1}
color6=${color6:1}

hyprctl keyword general:col.active_border "rgb($background) rgb($color6) 0deg"
