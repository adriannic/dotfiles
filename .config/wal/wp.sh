#! /bin/bash

function wallpaper() {
	(
		wal -n -i "$@"
		pywalfox update &
		swww img "$(<"${HOME}/.cache/wal/wal")" --transition-type=any --transition-fps=60 --transition-duration=2 &
		eww reload &
	  bash ~/.config/hypr/scripts/pywal.sh &
	) 2>&1 > /dev/null
}

wallpaper "$1"
