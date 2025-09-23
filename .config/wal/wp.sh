#! /usr/bin/env bash

function fix_qt_contrast() {
	BACKGROUND_COLOR=$(head -n1 ~/.cache/wal/colors)
	BACKGROUND_COLOR=${BACKGROUND_COLOR:1}
	COLOR=$(echo "0x$BACKGROUND_COLOR 0x101010" | awk --non-decimal-data '{printf("%06X\n", $1 + $2)}')
	sed -i "23s/""$BACKGROUND_COLOR""/""$COLOR""/g" ~/.cache/wal/Pywal-ADR.colors
}

function is_video() {
	if [[ "$1" =~ ^https?:// ]]; then
		return 0
	fi

	if [ -f "$1" ]; then
		if [[ "$1" =~ \.(mp4|mov|avi|mkv|flv|wmv|webm|mpg|mpeg|3gp)$ ]]; then
			return 0
		fi

		if file -b --mime-type "$1" | grep -q '^video/'; then
			return 0
		fi
	fi

	return 1
}

function wallpaper() {
	mkdir -p ~/.cache/wallpaper/
	tmp="$(mktemp).png"

	mpvpaper_present=$(
		mpvpaper --help >/dev/null 2>&1
		echo $?
	)

	if is_video "$1" && [[ $(mpvpaper --help >/dev/null 2>&1; echo $?) != 0 ]]; then
		notify-send "No se pudo cambiar el fondo de pantalla" "No está presente mpvpaper"
		exit 1
	fi

	if echo "$1" | grep -E 'youtube|twitch' >/dev/null; then
		echo -n "$1" >~/.cache/wallpaper/selected
		ffmpeg -i "$(yt-dlp -g "$1" | head -n1)" -vf "select=eq(n\,180)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	else
		echo -n "$(readlink -f "$1")" >~/.cache/wallpaper/selected
		ffmpeg -i "$1" -vf "select=eq(n\,0)" -vframes 1 -q:v 3 "$tmp" >/dev/null 2>&1
	fi

	(
		procs="$(pgrep mpvpaper)"
		if is_video "$1"; then
			swww kill
			mpvpaper -o "volume=100 loop" '*' "$1" --fork
		else
			swww-daemon & disown
			swww img --transition-type any --transition-fps 60 --transition-duration 1 "$1" &
		fi
		wal -n -i "$tmp"
		fix_qt_contrast &
		# pywalfox update &
		walogram &
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
