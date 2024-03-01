#! /usr/bin/env bash

function wallpaper() {
	tmp="$(mktemp).png"
	ffmpeg -i "$1" -vf "select=eq(n\,0)" -q:v 3 "$tmp"
	(
		swww img "$1" -t none &
		wal -n -i "$1"
		pywalfox update &
	  bash ~/.config/hypr/scripts/pywal.sh &
	  swaync-client -rs &
	  notify-send -i "$tmp" "Fondo de pantalla cambiado" "Fondo de pantalla y esquema de colores cambiado a $(basename "$1")"
	  killall ags && ags &
	  disown
	) > /dev/null 2>&1
}

wallpaper "$1"
