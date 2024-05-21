#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim
ln -s $(pwd)/zshrc $HOME/.zshrc
ln -s $(pwd)/config $HOME/.config

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"
