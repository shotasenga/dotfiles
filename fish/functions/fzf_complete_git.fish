function fzf_complete_git
    set -l subcmd $argv[2]

    switch $subcmd
        case add
            git status -s | fzf -m -q (commandline -t) | awk '{print $2}'
        case fixup
        case show
            git log --pretty=format:"%C(auto)%h %s [Author:%an <%ae>]" | fzf --no-sort -q (commandline -t) | awk '{print $1}'
        case '*'
            git branch --format '%(refname:lstrip=2)' | fzf +m -q (commandline -t)
    end
end
