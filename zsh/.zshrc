# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Universal Aliases
alias nivm="nvim"
alias config="cd ~/.config/nvim/lua/daniel/"

alias windows="cd /mnt/c/Users/danie/Documents"
alias school="cd /mnt/c/Users/danie/Documents/School/OU/junior25/"
alias projects="cd /mnt/c/Users/danie/Documents/Personal/Projects/"

# Dev Environment PATH things
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

. "$HOME/.cargo/env"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

bindkey -s ^f "~/.local/bin/scripts/tmux-sessionizer\n"
