if status is-interactive
    # Commands to run in interactive sessions can go here
    neofetch

    # Aliases
    alias ls="exa -ghmuU --git"
    alias ip="ip -color=auto"
    alias l="ls -la"
    alias la="ls -a"
    alias ll="ls -l"
    alias diff="diff --color=auto"
    alias grep="grep --color=auto"
    alias myip="curl http://ipecho.net/plain; echo"
    alias space="du -ahd1 2> /dev/null | sort -h"
    alias bye="shutdown now"
    alias cya="reboot"
    alias open="xdg-open"
    alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

    ## Desktop specific aliases
    alias towindows="systemctl reboot --boot-loader-entry=auto-windows"

    # Functions
    function burn
        sudo dd bs=4M if=$argv[1] of=$argv[2] conv=fsync oflag=direct status=progress
    end

    function wp
	    wal -n -i "$argv" &> /dev/null
	    pywalfox update &> /dev/null &
	    swww img "$(cat ~/.cache/wal/wal)" --transition-type=any --transition-fps=60 --transition-duration=2 &> /dev/null &
	    eww reload &> /dev/null & 
    end

    function randwp
        bash ~/.config/wal/random-bg.sh &> /dev/null
    end

    [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

    starship init fish | source
    enable_transience
end

