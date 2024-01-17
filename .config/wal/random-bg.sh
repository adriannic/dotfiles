#! /bin/bash

bgs=(~/Imágenes/Fondos/*)

size=${#bgs[@]}
index=$((RANDOM % size))

~/.config/wal/wp.sh "${bgs[$index]}"
