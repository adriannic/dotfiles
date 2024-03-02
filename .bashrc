#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

[[ "$USER" = "adriannic" ]] && (cat ~/.cache/wal/sequences &)
