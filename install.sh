#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim
ln -s $(pwd)/zshrc $HOME/.zshrc

ln -s $(pwd)/config/nvim/init.vim $HOME/.config/nvim/init.vim

ln -s $(pwd)/config/nvim/lua/init.lua $HOME/.config/nvim/lua/init.lua
ln -s $(pwd)/config/nvim/lua/lewis/init.lua $HOME/.config/nvim/lua/lewis/init.lua
ln -s $(pwd)/config/nvim/lua/lewis/packer.lua $HOME/.config/nvim/lua/lewis/packer.lua
ln -s $(pwd)/config/nvim/lua/lewis/remap.lua $HOME/.config/nvim/lua/lewis/remap.lua

ln -s $(pwd)/config/nvim/after/plugin/harpoon.lua $HOME/.config/nvim/after/plugin/harpoon.lua
ln -s $(pwd)/config/nvim/after/plugin/lsp.lua $HOME/.config/nvim/after/plugin/lsp.lua
ln -s $(pwd)/config/nvim/after/plugin/neotest.lua $HOME/.config/nvim/after/plugin/neotest.lua
ln -s $(pwd)/config/nvim/after/plugin/telescope.lua $HOME/.config/nvim/after/plugin/telescope.lua
ln -s $(pwd)/config/nvim/after/plugin/treesitter.lua $HOME/.config/nvim/after/plugin/treesitter.lua
ln -s $(pwd)/config/nvim/after/plugin/undotree.lua $HOME/.config/nvim/after/plugin/undotree.lua

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"
