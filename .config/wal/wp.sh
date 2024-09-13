#! /usr/bin/env bash

function wallpaper() {
	mkdir -p ~/.cache/wallpaper/
	tmp="$(mktemp).png"

	if echo "$1" | grep 'youtube|twitch'; then
		echo -n "$1" >~/.cache/wallpaper/selected
		ffmpeg -i "$(yt-dlp -g "$1" | head -n1)" -vf "select=eq(n\,180)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	else
		echo -n "$(readlink -f "$1")" >~/.cache/wallpaper/selected
		ffmpeg -i "$1" -vf "select=eq(n\,0)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	fi

	(
		pkill mpvpaper
		mpvpaper -o "volume=100 loop" '*' "$1" --fork &
		wal -n -i "$tmp"
		pywalfox update &
		bash ~/.config/hypr/scripts/pywal.sh &
		swaync-client -rs &
		notify-send -i "$tmp" "Fondo de pantalla cambiado" "Fondo de pantalla y esquema de colores cambiado a $(basename "$1")"
		pkill ags && ags &
		disown
	) >/dev/null 2>&1
}

wallpaper "$1"
