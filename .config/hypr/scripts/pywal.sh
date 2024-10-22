#! /usr/bin/env bash

source "$HOME/.cache/wal/colors.sh"

background=${background:1}
color2=${color2:1}

hyprctl keyword general:col.active_border "rgb($background) rgb($color2) 0deg"
