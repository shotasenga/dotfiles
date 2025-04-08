#!/bin/bash

set -ex

DOT_DIR=$(realpath $(dirname "${BASH_SOURCE[0]}"))

# Install yay
if [ ! $(command -v yay) ]; then
    INSTALL_TARGET_DIR=/opt/yay
    sudo pacman -S --needed --needed git base-devel
    # TODO: make sure the <directory> option works as expected
    sudo git clone https://aur.archlinux.org/yay.git /opt/yay
    sudo chown -R "${USER}:wheel" /opt/yay
    cd /opt/yay
    makepkg -si
    cd -
fi

# update packages
sudo pacman -Sy archlinux-keyring
yay

mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"

# TODO: consider yay -S --needed - < installs.txt

# Xorg
sudo pacman -S --needed autorandr acpid # external monitor
yay -S --needed xidlehook
# TODO: confirm what packages are needed. I _guess_ xorg is a bundle and it includes xorg-xinit.
# sudo pacman -S --needed xorg xorg-xinit xf86-video-intel mesa
# sudo pacman -S --needed xdg-utils # https://wiki.archlinux.org/title/Xdg-utils

ln -Tfs $DOT_DIR/xorg/xinitrc "${HOME}/.xinitrc"
ln -Tfs $DOT_DIR/xorg/xprofile "${HOME}/.xprofile"
ln -Tfs $DOT_DIR/xorg/Xresources "${HOME}/.Xresources"
ln -Tfs $DOT_DIR/gtk/gtkrc-2.0 "${HOME}/.gtkrc-2.0"
ln -Tfs $DOT_DIR/autorandr "${XDG_CONFIG_HOME:-$HOME/.config}/autorandr"
# sudo cp -a $DOT_DIR/x11/acpid/autorandr.sh /etc/acpid/autorandr.sh # ensure the file is executable
# sudo cp -a $DOT_DIR/x11/acpid/events/lid-switch /etc/acpi/events/lid-switch
# sudo cp -a $DOT_DIR/xorg/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
# sudo cp -a $DOT_DIR/xorg/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf


# GUI environmneet
sudo pacman -S --needed i3-wm xss-lock i3lock polkit
sudo pacman -S --needed rofi dunst maim xclip
yay -S --needed dragon-drop kmonad-bin

ln -Tfs $DOT_DIR/i3 "${XDG_CONFIG_HOME:-$HOME/.config}/i3"
ln -Tfs $DOT_DIR/dunst "${XDG_CONFIG_HOME:-$HOME/.config}/dunst"
# cp -a "${XDG_CONFIG_HOME:-$HOME/.config}/kmonad" /etc/kmonad


# Terminal
sudo pacman -S --needed wezterm alacritty ghostty
# sudo pacman -S --needed wezterm alacritty
sudo pacman -S --needed fish fzf fd tmux
yay -S --needed autojump

ln -Tfs $DOT_DIR/fish "${XDG_CONFIG_HOME:-$HOME/.config}/fish"
ln -Tfs $DOT_DIR/tmux/tmux.conf "${HOME}/.tmux.conf"
ln -Tfs $DOT_DIR/tmux/tmux.arch.conf "${HOME}/.tmux.env.conf"
ln -Tfs $DOT_DIR/wezterm "${XDG_CONFIG_HOME:-$HOME/.config}/wezterm"

if [[ "$SHELL" != *fish ]]; then
    echo run the command below to change your shell to fish
    echo -e "\tchsh -s /usr/bin/fish"
fi

mkdir -p "${HOME}/.tmux"
if [ ! -e "${HOME}/.tmux/tmux-open" ]; then
    # https://github.com/tmux-plugins/tmux-open
    git clone git@github.com:tmux-plugins/tmux-open.git "${HOME}/.tmux/tmux-open"
fi


# Dev tools
echo TODO: You need to manully run `all-the-icons-install-fonts` for the icons on Emacs
sudo pacman -S --needed git github-cli openssh diff-so-fancy emacs neovim bat plocate udisks2 tree htop jq
sudo pacman -S --needed mise

ln -Tfs $DOT_DIR/git "${XDG_CONFIG_HOME:-$HOME/.config}/git"
ln -Tfs $DOT_DIR/mise "${XDG_CONFIG_HOME:-$HOME/.config}/mise"
ln -Tfs $DOT_DIR/emacs "${HOME}/.emacs.d"
ln -Tfs $DOT_DIR/nvim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
ln -Tfs $DOT_DIR/bin "${HOME}/.bin"

if [ ! -f ${HOME}/.ssh/id_ed25519 ]; then
    echo You mway want to create ssh key and add it to Github
    echo -e "\tssh-keygen -t ed25519 -C '${USER}@${HOSTNAME}'"
    echo Or you can use github-cli
    echo -e "\tgh auth login"
fi

bash $DOT_DIR/gh/gh-extensions.sh


# Fonts
sudo pacman -S --needed ttf-hack


# Other applications
yay -S --needed syncthing anki-official-binary-bundle google-chrome slack-desktop


echo COMPLETED 🎉
