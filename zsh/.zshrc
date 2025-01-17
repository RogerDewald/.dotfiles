# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git)
source $ZSH/oh-my-zsh.sh

#Universal Aliases
alias config="cd ~/.config/nvim/lua/daniel/"
alias nivm="nvim"
alias cpuinfo="cat /proc/cpuinfo"

#Laptop Aliases
alias sleep="systemctl suspend"
alias suspend="systemctl suspend"
alias shutdown="shutdown -h now"
alias restart="reboot"
alias battery="upower -i $(upower -e | grep 'BAT') | grep -E 'state|to\ full|percentage'"
alias volume="alsamixer"
alias wifi="nmtui"
alias settings="gnome-control-center"
alias bluetooth="blueman-manager"
alias bcontrol="sudo brightnessctl set"

alias bup="sudo brightnessctl set +10%"
alias bdown="sudo brightnessctl set 10%-"
alias blow="sudo brightnessctl set 2667"
alias bhigh="sudo brightnessctl set 26666"
alias bhalf="sudo brightnessctl set 13333"

alias vm="virt-manager"
alias bighousevpn="sudo openvpn --config ~/Downloads/Unsorted/Church_in_Norman_VPN_Server_ddewald_laptop.ovpn"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

bindkey -s ^f "~/.local/bin/scripts/tmux-sessionizer\n"

# export PATH="/usr/local/mcuxpressoide/ide:$PATH"
export PATH="/usr/local/mcuxpressoide/ide/plugins/com.nxp.mcuxpresso.tools.bin.linux_24.12.0.202407110909/binaries:/usr/local/mcuxpressoide/ide/plugins/com.nxp.mcuxpresso.tools.linux_24.12.0.202407110909/tools/bin:/usr/local/mcuxpressoide/ide:/home/daniel/.local/bin:/usr/local/mcuxpressoide/ide:$PATH"

alias mcu="mcuxpressoide"

unsetopt AUTO_CD
