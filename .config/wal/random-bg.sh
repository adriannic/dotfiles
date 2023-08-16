#! /bin/bash

function wallpaper() {
	(
		wal -n -i "$@"
		pywalfox update &
		swww img "$(<"${HOME}/.cache/wal/wal")" --transition-type=any --transition-fps=60 --transition-duration=2 &
		eww reload &
	) 2>&1 > /dev/null
}

i=0
for bg in ~/Imágenes/Fondos/*; do
  array[i]=$bg;
  ((i=i+1))
done

size=${#array[@]}
index=$((RANDOM % size))

wallpaper "${array[$index]}"
