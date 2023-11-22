#! /bin/bash

function wallpaper() {
	(
		swww img "$@" -t none &
		wal -n -i "$@"
		pywalfox update &
	  bash ~/.config/hypr/scripts/pywal.sh &
	  swaync-client -rs &
	  killall ags && ags &
	  disown
	) > /dev/null 2>&1
}

wallpaper "$1"
