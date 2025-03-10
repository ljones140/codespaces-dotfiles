#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim

mkdir -p $HOME/.config/nvim/ && ln -s $(pwd)/config/nvim/* $HOME/.config/nvim

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Install geometry oh my zsh theme
git clone https://github.com/geometry-zsh/geometry
ln -s $(pwd)/geometry/geometry.zsh $HOME/.oh-my-zsh/themes/geometry.zsh-theme

mdir -p $HOME/lewis_bin
cp $(pwd)/lewis_bin/* $HOME/lewis_bin
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
source $HOME/.zshrc


if [[node -v]]; then
  echo "Installing Node"
  # Download and install nvm:
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

   # in lieu of restarting the shell
   \. "$HOME/.nvm/nvm.sh"

  # Download and install Node.js:
  nvm install 22 > /dev/null
fi

echo
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
if [ $? -eq 0 ]; then
  echo "Success, installing..."
  rm $HOME/.local/bin/nvim
  tar -C $HOME/.local/opt -xzf nvim-linux-x86_64.tar.gz
  ln -s $HOME/.local/opt/nvim-linux-x86_64/bin/nvim $HOME/.local/bin/nvim
  echo "Bootstrapping neovim config... (may take some time)"

  # installing packer
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

  source $HOME/.vimrc
  # installing .vimrc plugins
  nvim --headless "+PlugInstall" +qa > /dev/null

  # installing packer nvim plugins
  nvim -u $HOME/.config/nvim/lua/lewis/packer.lua --headless +so +PackerSync +qa > /dev/null
  # nvim -u $HOME/.config/nvim/lua/lewis/packer.lua --headless +PackerSync +qa > /dev/null
  # setup lanuage servers
  # nvim --headless "+MasonInstall typescript-language-server eslint-lsp golangci-lint gopls buf_ls" +qa > /dev/null 2> /dev/null

  if [[ $PATH != *"$HOME/.local/bin"* ]]; then
    echo "Adding path to $HOME/.profile"
    echo "" >> $HOME/.profile
    echo "# add dot-local path" >> $HOME/.profile
    echo -e "export PATH=\$HOME/.local/bin:\$PATH" >> $HOME/.profile
  fi

  if [[ -z $(grep "alias vi=\"nvim\"" $shell_file) ]]; then
    echo "Adding alias to $shell_file"
    echo "" >> $shell_file
    echo -e "alias vi=\"nvim\"" >> $shell_file
    echo -e "alias vim=\"nvim\"" >> $shell_file
  fi
  echo "Done bootstrapping neovim (nvim)."
  echo
  echo "Installed at:"
  echo "$HOME/.local/opt/$nvim_file_part ->"
  echo "$HOME/.local/bin/nvim"
  echo
else
  echo "Failed to download neovim, aborting."
fi
