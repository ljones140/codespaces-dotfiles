#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim

mkdir -p $HOME/.config/nvim/ && ln -s $(pwd)/config/nvim/* $HOME/.config/nvim

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"

# Save the existing zshrc file
if [[ -n "$CODESPACES" && -e "$HOME/.zshrc" ]]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc_cs"

    # Clean up unwanted lines from the Codespaces zshrc file
    sed -i '1,/# Example aliases/d' "$HOME/.zshrc_cs"
fi

# Copy over .zshrc file
cp $(pwd)/zshrc $HOME/.zshrc

# Merge the zshrc with the pre-existing one
if [[ -n "$CODESPACES" && -e "$HOME/.zshrc_cs" ]]; then
    cat "$HOME/.zshrc_cs" >> "$HOME/.zshrc"
fi
