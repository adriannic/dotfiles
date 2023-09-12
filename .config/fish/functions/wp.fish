function wp --description 'Change wallpaper to the desired one'
	wal -n -i "$argv" &> /dev/null
	pywalfox update &> /dev/null &
	swww img "$(cat ~/.cache/wal/wal)" --transition-type=any --transition-fps=60 --transition-duration=2 &> /dev/null &
	eww reload &> /dev/null & 
	swaync-client -rs &
	bash ~/.config/hypr/scripts/pywal.sh &> /dev/null &
end
