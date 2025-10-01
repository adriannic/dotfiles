#
# ~/.bash_profile
#

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_DATA_HOME=$HOME/.local/share
export XDG_MENU_PREFIX=arch-
export XDG_PICTURES_DIR=$HOME/Imágenes/Capturas
export XDG_SESSION_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_STATE_HOME=$HOME/.local/state

export CLUTTER_BACKEND=wayland
export EDITOR="nvim"
export GDK_BACKEND=wayland,x11
export HYPRSHOT_DIR=~/Imágenes/Capturas
export PAGER="bat"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XCURSOR_PATH=/usr/share/icons/:${XDG_DATA_HOME}/icons/:${HOME}/.icons/:${HOME}/.nix-profile/share/icons/
export XCURSOR_SIZE=24

export GOPATH="$XDG_DATA_HOME"/go
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export KODI_DATA="$XDG_DATA_HOME"/kodi
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export WINEPREFIX="$XDG_DATA_HOME"/wine
export ZDOTDIR="$HOME"/.config/zsh
# shellcheck disable=2155
export MAKEFLAGS="-j $(nproc)"

export ROCM_PATH=/opt/rocm/
export CUDA_PATH=/opt/cuda/
export HSA_OVERRIDE_GFX_VERSION=10.3.0

[ "$(tty)" = "/dev/tty1" ] && exec Hyprland

[[ -f ~/.bashrc ]] && . "$HOME"/.bashrc
