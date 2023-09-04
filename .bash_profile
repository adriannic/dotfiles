#
# ~/.bash_profile
#

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CLUTTER_BACKEND=wayland
export EDITOR="nvim"
export GDK_BACKEND=wayland,x11
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export HYPRSHOT_DIR=~/Imágenes/Capturas
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export PAGER="less"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XCURSOR_PATH=/usr/share/icons:${XDG_DATA_HOME}/icons
export XCURSOR_SIZE=24
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_DATA_HOME=$HOME/.local/share
export XDG_SESSION_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_STATE_HOME=$HOME/.local/state

[ "$(tty)" = "/dev/tty1" ] && exec Hyprland

[[ -f ~/.bashrc ]] && . "$HOME"/.bashrc
