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

status "Backing up old dotfiles and moving new ones into place in $HOME/"
for x in ${dotfiles_array[@]}; do
    if [[ -e ~/.$x ]]; then
        cp ~/.$x ~/.dotfiles-backup/
    fi   
    cp $script_path/.$x ~/.$x
done

status "Installing Vim plugins"
vim +PlugInstall
