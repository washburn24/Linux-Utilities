source /usr/share/cachyos-fish-config/cachyos-config.fish

# Defining useful aliases and functions and claiming some back from Cachy's default config
alias vi="vim"
alias ff="fastfetch"
if type -q eza    # Make sure eza exists before pointing ls to it
    alias ls="eza --color=always --group-directories-first --icons"
end
alias update="echo 'sudo pacman -Syu' ; sudo pacman -Syu"
alias refresh="exec $SHELL"
alias cls="clear"

function sudo
    if functions -q -- $argv[1]
        set -- argv -- fish -c "$(functions --no-details -- $argv[1]); $argv"
    end
    command sudo $argv
end

function fish_greeting
    pwd
    ls
end
