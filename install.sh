#!/bin/bash

DEBUG=1

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

status () {
    echo -e "${Green}==> $1${Color_Off}"
}

die() {
    echo -e "${Red}==> $1${Color_Off}"
    exit
}

    
if [ $DEBUG -ne 0 ]; then
    status "Debug mode on"
    set -x
fi

script_path=$(dirname $(readlink -f "$0"))
dotfiles_array=("vimrc" "zshrc" "zshenv")

#TODO(tgoetsch): add support for pre-existing '.dotfiles-backup' directory
status "Making backup dotfiles directory in $HOME/"
mkdir -p ~/.dotfiles-backup

status "Backing up old dotfiles"
for x in ${dotfiles_array[@]}; do
    if [[ -e ~/.$x ]]; then
        cp ~/.$x ~/.dotfiles-backup/
        status "backup $x ... done"
    fi   
done

# install oh-my-zsh if it isn't already installed. 
# Do before moving new dotfiles into place since .zshrc file will be replaced by oh-my-zsh.
if [[ ! $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

status "Moving new dotfiles into place in $HOME/"
for x in #{dotfiles_array[@]}; do
    cp $script_path/.$x ~/.$x
        status "move $x ... done"
done

status "Installing Vim plugins"
vim +PlugInstall
