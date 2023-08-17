#! /bin/bash

. "$HOME/.cache/wal/colors.sh"

exec swaylock --line-color="$background" --inside-color="$background" --ring-color="$color1" --text-color="$foreground" --key-hl-color="$foreground" --separator-color="$foreground"
