#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim
ln -s $(pwd)/zshrc $HOME/.zshrc

mkdir -p $HOME/.config/nvim/ && ln -s $(pwd)/config/nvim/* $HOME/.config/nvim

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"

cd $HOME/.config/nvim/lua
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync
