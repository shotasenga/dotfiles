# TODO: replace with ~~rtx~~ mise
function fzf_complete_asdf
    set -l subcmd $argv[2]

    switch $subcmd
        case install
            asdf list-all $argv[3] | fzf -m +s --tac -q (commandline -t)
        case uninstall
            asdf list $argv[3] | fzf -m +s --tac -q (commandline -t)
        case '*'
            return
    end
end
