# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export EDITOR='vim'

#plugins
plugins=(git npm ruby bundler zsh-autosuggestions copypath copyfile zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

#speed up escape in vim
# 10ms for key sequences
KEYTIMEOUT=1

ssh-add -A &> /dev/null
alias zshconfig="mate ~/.zshrc"
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gk='gitk --all&'
alias gx='gitx --all'
alias tas='tmux attach-session -t'
alias start-actions='echo Actions is no longer part of the default dev container, launch the Actions-specific configuration. See https://gh.io/AAmjooh'
alias toggle-four-nines='echo Actions is no longer part of the default dev container, launch the Actions-specific configuration. See https://gh.io/AAmjooh'
alias ff='bin/toggle-feature-flag'
alias memex='npm run -w @github-ui/memex'

