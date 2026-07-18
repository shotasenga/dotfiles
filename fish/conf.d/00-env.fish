set -x LANG en_US.UTF-8

set -x XDG_CONFIG_HOME $HOME/.config

set -x EDITOR nvim
set -x VISUAL $EDITOR

switch (uname)
    case Linux
        # echo linux
    case Darwin
        set -l BREW_HOME
        if test -e /opt/homebrew
          set BREW_HOME /opt/homebrew
        else
          set BREW_HOME /usr/local
        end

        set -x PATH $BREW_HOME/bin $PATH
        set -x PATH $BREW_HOME/sbin $PATH
        set -x PATH $BREW_HOME/opt/coreutils/libexec/gnubin $PATH
        set -x PATH $BREW_HOME/opt/findutils/libexec/gnubin $PATH
        set -x PATH $BREW_HOME/opt/gnu-sed/libexec/gnubin $PATH
        set -x PATH /Applications/Emacs.app/Contents/MacOS/bin $PATH
        set -x PATH $HOME/Library/pnpm/bin $PATH
        set -x PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $PATH

        set -x DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"
end

set -x PATH $HOME/.local/bin $PATH
