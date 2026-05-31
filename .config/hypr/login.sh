#!/usr/bin/env bash

for i in $(hyprctl monitors -j | jq '.[].id'); do
  hyprctl dispatch "hl.dsp.exec_cmd(\"mpv --fs --pause --no-input-default-bindings --no-input-cursor --input-ipc-server=/tmp/mpvsocket-$i ~/.config/hypr/login.mkv\", { monitor = \"$i\" , no_anim = true, stay_focused = true })"
done

for socket in /tmp/mpvsocket-*; do
  (sleep 5 && echo 'cycle pause' | socat - "$socket") &
done
