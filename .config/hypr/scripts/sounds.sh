#! /usr/bin/env bash

handle() {
  case $1 in
  openwindow*)  mpv --no-video --volume=60 ~/.config/audio/sonic/open.wav >/dev/null 2>&1 & ;;
  closewindow*) mpv --no-video --volume=60 ~/.config/audio/sonic/close.wav >/dev/null 2>&1 & ;;
  openlayer*)   mpv --no-video --volume=60 ~/.config/audio/sonic/pause.wav >/dev/null 2>&1 & ;;
  closelayer*)  mpv --no-video --volume=60 ~/.config/audio/sonic/confirm.wav >/dev/null 2>&1 & ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
