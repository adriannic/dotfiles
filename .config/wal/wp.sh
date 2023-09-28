#! /bin/bash

function wallpaper() {
	(
		wal -n -i "$@"
		pywalfox update &
		swww img "$(<"${HOME}/.cache/wal/wal")" --transition-type=simple --transition-step=255 &
		eww reload &
	  bash ~/.config/hypr/scripts/pywal.sh &
	  swaync-client -rs &
	) 2>&1 > /dev/null
}

wallpaper "$1"
