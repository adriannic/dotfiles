#! /usr/bin/env bash

function fix_qt_contrast() {
	BACKGROUND_COLOR=$(head -n1 ~/.cache/wal/colors)
	BACKGROUND_COLOR=${BACKGROUND_COLOR:1}
	COLOR=$(echo "0x$BACKGROUND_COLOR 0x101010" | awk --non-decimal-data '{printf("%06X\n", $1 + $2)}')
	sed -i "23s/""$BACKGROUND_COLOR""/""$COLOR""/g" ~/.cache/wal/Pywal-ADR.colors
}

function wallpaper() {
	mkdir -p ~/.cache/wallpaper/
	tmp="$(mktemp).png"

	if echo "$1" | grep -E 'youtube|twitch' >/dev/null; then
		echo -n "$1" >~/.cache/wallpaper/selected
		ffmpeg -i "$(yt-dlp -g "$1" | head -n1)" -vf "select=eq(n\,180)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	else
		echo -n "$(readlink -f "$1")" >~/.cache/wallpaper/selected
		ffmpeg -i "$1" -vf "select=eq(n\,0)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	fi

	(
		procs="$(pgrep mpvpaper)"
		mpvpaper -o "volume=100 loop" '*' "$1" --fork
		wal -n -i "$tmp"
		fix_qt_contrast &
		pywalfox update &
		walogram &
		bash ~/.config/hypr/scripts/pywal.sh &
		# swaync-client -rs &
		ags quit && ags run &
		pkill swayosd-server
		swayosd-server &
		sleep 0.5
		for p in $procs; do
			kill "$p"
		done
		notify-send -i "$tmp" "Fondo de pantalla cambiado" "Fondo de pantalla y esquema de colores cambiado a $(basename "$1")"
		pkill polkit-gnome
		/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
		disown
	) >/dev/null 2>&1
}

wallpaper "$1"
