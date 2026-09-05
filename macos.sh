#!/bin/bash

set -ex

DOT_DIR=$(realpath $(dirname "${BASH_SOURCE[0]}"))

include_extra=false
for arg in "$@"; do
  case "$arg" in
    --extra)
      include_extra=true
      ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [--extra]" >&2
      exit 2
      ;;
  esac
done

set HOMEBREW_NO_AUTO_UPDATE=1

if [ $(which brew) ]; then
    brew update
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if test -e /opt/homebrew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
else
  eval "$(/usr/local/bin/brew shellenv)"
  PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
fi

brew bundle --file $DOT_DIR/Brewfile || true

if $include_extra; then
  brew bundle --file $DOT_DIR/Brewfile-extra || true
else
  echo 'Skip extra packages'
fi

mas upgrade

# WARN: it replaces the target files if exist
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"

# GUI environmneet
ln -Tfs $DOT_DIR/karabiner "${HOME}/.config/karabiner"


# Terminal
ln -Tfs $DOT_DIR/fish "${XDG_CONFIG_HOME:-$HOME/.config}/fish"
ln -Tfs $DOT_DIR/tmux/tmux.conf "${HOME}/.tmux.conf"
ln -Tfs $DOT_DIR/tmux/tmux.mac.conf "${HOME}/.tmux.env.conf"
ln -Tfs $DOT_DIR/wezterm "${XDG_CONFIG_HOME:-$HOME/.config}/wezterm"
ln -Tfs $DOT_DIR/alacritty "${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
ln -Tfs $DOT_DIR/ghostty "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
ln -Tfs $DOT_DIR/cmux "${XDG_CONFIG_HOME:-$HOME/.config}/cmux"

# - fish as default shell
FISH_BIN=$(brew --prefix)/bin/fish
if ! grep -q $FISH_BIN /etc/shells; then
    sudo bash -c "echo ${FISH_BIN} >> /etc/shells"
fi

if [[ "$SHELL" != *fish ]]; then
    chsh -s $FISH_BIN
fi

# - tmux plugins
if [ ! -d "${HOME}/.tmux/plugins" ]; then
    mkdir -p "${HOME}/.tmux/plugins"
fi

if [ ! -e "${HOME}/.tmux/plugins/tpm" ]; then
    # https://github.com/tmux-plugins/tpm
    git clone git@github.com:tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"
fi

# - ssh key
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "${USER}@${HOSTNAME}"
    gh auth login
fi

# - gh extensions
bash $DOT_DIR/gh/gh-extensions.sh


# Dev tools
ln -Tfs $DOT_DIR/git "${XDG_CONFIG_HOME:-$HOME/.config}/git"
ln -Tfs $DOT_DIR/mise "${XDG_CONFIG_HOME:-$HOME/.config}/mise"
ln -Tfs $DOT_DIR/emacs "${HOME}/.emacs.d"
ln -Tfs $DOT_DIR/nvim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
ln -Tfs $DOT_DIR/helix "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
mkdir -p "${HOME}/.local/bin"
for script in "${DOT_DIR}"/bin/*; do
  ln -Tfs "${script}" "${HOME}/.local/bin/$(basename "${script}")"
done
ln -Tfs $DOT_DIR/claude-code-router "${HOME}/.claude-code-router"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zed"
ln -Tfs $DOT_DIR/zed/keymap.json "${XDG_CONFIG_HOME:-$HOME/.config}/zed/keymap.json"
ln -Tfs $DOT_DIR/zed/settings.json "${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json"


# Browser
defaultbrowser firefox
# ln -Tfs $DOT_DIR/finicky/finicky.js "${HOME}/.finicky.js"

# OS preference
# use `defaults delete <application> [config]` to go back to the default
defaults write -g NSMenuEnableActionImages -bool NO # hide icons in menu items
defaults write com.apple.universalaccess flashScreen -bool true # flash the screen on `beep`
# - dock
defaults write com.apple.dock tilesize -int 16 # set Dock icons to the smallest size
defaults write com.apple.dock magnification -bool true # magnify Dock icons on hover
defaults write com.apple.dock largesize -int 128 # set magnified Dock icons to the largest size
defaults write com.apple.dock orientation -string "left" # position the Dock on the left
defaults write com.apple.dock autohide -bool true # automatically hide the Dock
# - trackpad
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # disable natural scrolling
defaults write NSGlobalDomain AppleShowAllExtensions -bool true # show all filename extensions
defaults write com.apple.Finder AppleShowAllFiles -bool true # show hidden files in Finder
defaults write com.apple.finder ShowPathbar -bool true # show the path bar in Finder
# - keyboard
defaults write NSGlobalDomain KeyRepeat -int 3 # repeat held keys quickly
defaults write NSGlobalDomain InitialKeyRepeat -int 20 # shorten the delay before a held key repeats
defaults write NSAutomaticPeriodSubstitutionEnabled -bool false # disable automatic periods after double spaces
defaults write NSAutomaticDashSubstitutionEnabled -bool false # disable automatic dash substitution
defaults write NSAutomaticQuoteSubstitutionEnabled -bool false # disable smart quote substitution
defaults write -g ApplePressAndHoldEnabled -bool false # repeat held keys instead of showing the accent menu

echo COMPLETED 🎉
