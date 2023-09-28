#! /bin/bash

i=0
for bg in ~/Imágenes/Fondos/*; do
  array[i]=$bg;
  ((i=i+1))
done

size=${#array[@]}
index=$((RANDOM % size))

~/.config/wal/wp.sh "${array[$index]}"
