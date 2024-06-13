#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim

mkdir -p $HOME/.config/nvim/ && ln -s $(pwd)/config/nvim/* $HOME/.config/nvim

vim -Es -u $HOME/.vimrc -c "PlugInstall | qa"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/geometry-zsh/geometry ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/geometry
cp  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/geometry/geometry.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/geometry.zsh-theme

chmod 777 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/geometry.zsh-theme

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

# Always want to use ZSH as my default shell (e.g. for SSH)
sudo chsh -s /bin/zsh $(whoami)

