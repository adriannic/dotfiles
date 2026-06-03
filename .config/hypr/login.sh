#!/usr/bin/env bash

MONITORS=$(hyprctl monitors -j | jq '.[].id')
for i in $MONITORS; do
  hyprctl dispatch "hl.dsp.exec_cmd(\"mpv --fs --pause --no-input-default-bindings --no-input-cursor --input-ipc-server=/tmp/mpvsocket-$i ~/.config/hypr/login.mkv\", { monitor = \"$i\" , no_anim = true, stay_focused = true })"
done

for i in $MONITORS; do
  (sleep 1 && echo 'cycle pause' | socat - "/tmp/mpvsocket-$i") &
done
