# - $FZF_LIST_ALL     (default: "find .")
# - $FZF_LIST_FILE    (default: "find . -type f")
# - $FZF_LIST_DIR     (default: "find -type d")
# - $FZF_FILE_COMMAND (default: vim emacs less)
# - $FZF_DIR_COMMAND  (default: cd)

# Completers get the current process's tokens before the cursor's token as $argv
# and use the cursor's token (`commandline -t`) as the fzf query.
function fzf_complete -d "fuzzy search using fzf for the token under the cursor"
    set -l tokens (commandline -pcx)
    set -l func_name "fzf_complete_$tokens[1]"

    if type -q $func_name
        $func_name $tokens | __fzf_complete
    else
        __fzf_complete_fallback $tokens | __fzf_complete
    end
end

function __fzf_complete_fallback -d "fallback function for path completion"
    set -q FZF_LIST_ALL || set -l FZF_LIST_ALL "find ."
    set -q FZF_LIST_FILE || set -l FZF_LIST_FILE "find -type f"
    set -q FZF_LIST_DIR || set -l FZF_LIST_DIR "find -type d"

    set -q FZF_FILE_COMMAND or set -l FZF_FILE_COMMAND vim emacs less
    set -q FZF_DIR_COMMAND or set -l FZF_DIR_COMMAND cd

    set -l cmd $argv[1]

    if [ -z "$cmd" ]
        fzf_history
        return
    end

    switch $cmd
        case $FZF_FILE_COMMAND
            eval $FZF_LIST_FILE | fzf -m -q (commandline -t)
        case $FZF_DIR_COMMAND
            eval $FZF_LIST_DIR | fzf -m -q (commandline -t)
        case "*"
            eval $FZF_LIST_ALL | fzf -m -q (commandline -t)
    end
end

function __fzf_complete -d "replace the token under the cursor with STDIN"
    set -l result
    while read line
        set -a result $line
    end

    if set -q result[1]
        commandline -rt -- "$result"
    end
    commandline -f repaint
end
