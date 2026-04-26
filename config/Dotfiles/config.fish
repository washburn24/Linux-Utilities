source /usr/share/cachyos-fish-config/cachyos-config.fish

alias vi="vim"

function sudo
    if functions -q -- $argv[1]
        set -- argv -- fish -c "$(functions --no-details -- $argv[1]); $argv"
    end
    command sudo $argv
end
