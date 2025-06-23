#! /usr/bin/env bash

bgs=(~/Imágenes/Fondos/*)
selected=$(cat ~/.cache/wallpaper/selected)
aux=("${bgs[@]/$selected/}")
bgs=()
for elem in "${aux[@]}"; do
  if [[ "$elem" ]]; then
    bgs+=("$elem")
  fi
done
size=${#bgs[@]}
index=$((RANDOM % size))

~/.config/wal/wp.sh "${bgs[$index]}"
