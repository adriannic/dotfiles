if status is-interactive
    # Commands to run in interactive sessions can go here

    # Increase max number of file descriptors (fixes nvim needing a lot of files open at the same time)
    ulimit -n 4096

    # Aliases
    alias bye="shutdown now"
    alias cya="reboot"
    alias diff="diff --color=auto"
    alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
    alias grep="grep --color=auto"
    alias ip="ip -color=auto"
    alias l="ls -la"
    alias la="ls -a"
    alias ll="ls -l"
    alias ls="lsd"
    alias myip="curl http://ipecho.net/plain; echo"
    alias open="xdg-open"
    alias space="du -ahd1 2> /dev/null | sort -h"

    ## Desktop specific aliases
    alias towindows="systemctl reboot --boot-loader-entry=auto-windows"

    [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

    starship init fish | source
    zoxide init fish --cmd cd | source
    enable_transience
    fastfetch
end
