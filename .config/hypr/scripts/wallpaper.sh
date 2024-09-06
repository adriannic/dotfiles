#! /usr/bin/env bash

if ls ~/.cache/wallpaper/selected; then
  bash ~/.config/wal/wp.sh "$(cat ~/.cache/wallpaper/selected)"
else
  bash ~/.config/wal/random-bg.sh
fi
