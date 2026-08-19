# ~/.zshrc — shared across every machine.
#
# Machine-specific settings do NOT belong in this file. They go in
#   ~/.config/zsh/hosts/<host>.zsh        (loaded after oh-my-zsh)
#   ~/.config/zsh/hosts/<host>.pre.zsh    (loaded before oh-my-zsh)
# and anything private or one-off goes in ~/.zshrc.local, which is not
# tracked by git. See the README for how <host> is resolved.

ZSH_CONFIG_DIR="${HOME}/.config/zsh"

# ---------------------------------------------------------------------------
# Which machine is this?
# ---------------------------------------------------------------------------
# Resolution order, first hit wins:
#   1. $DOTFILES_HOST from the environment (set it in ~/.zshenv)
#   2. the single line in ~/.config/zsh/host   (untracked, easiest option)
#   3. "wsl", auto-detected from /proc/version
#   4. the short hostname
#   5. "default"
if [[ -z "$DOTFILES_HOST" ]]; then
    if [[ -r "${ZSH_CONFIG_DIR}/host" ]]; then
        DOTFILES_HOST="$(<"${ZSH_CONFIG_DIR}/host")"
    elif [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
        DOTFILES_HOST="wsl"
    else
        DOTFILES_HOST="${HOST%%.*}"
    fi
fi
# Fall back to default.zsh rather than silently loading nothing, so a new
# machine with no host file still gets a sane shell.
if [[ ! -r "${ZSH_CONFIG_DIR}/hosts/${DOTFILES_HOST}.zsh" ]]; then
    DOTFILES_HOST="default"
fi
export DOTFILES_HOST

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
# These have to be set BEFORE oh-my-zsh.sh is sourced, which is the whole
# reason the .pre.zsh half exists.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
plugins=(git)

[[ -r "${ZSH_CONFIG_DIR}/hosts/${DOTFILES_HOST}.pre.zsh" ]] \
    && source "${ZSH_CONFIG_DIR}/hosts/${DOTFILES_HOST}.pre.zsh"

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------------------------------
# Aliases that make sense everywhere
# ---------------------------------------------------------------------------
alias config="cd ~/.config/nvim/lua/daniel/"
alias nivm="nvim"                 # the typo I make often enough to alias
alias cpuinfo="cat /proc/cpuinfo"

# ---------------------------------------------------------------------------
# Node (nvm)
# ---------------------------------------------------------------------------
# Both layouts have been used on these machines, so take whichever exists.
if [[ -n "${XDG_CONFIG_HOME:-}" && -d "${XDG_CONFIG_HOME}/nvm" ]]; then
    export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
else
    export NVM_DIR="$HOME/.nvm"
fi
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ---------------------------------------------------------------------------
# tmux-sessionizer (stow the `bin` package to get it)
# ---------------------------------------------------------------------------
# Guarded, so ^f is only bound when the script is actually installed —
# otherwise the keybind silently runs nothing.
[[ -x "$HOME/.local/bin/scripts/tmux-sessionizer" ]] \
    && bindkey -s ^f "~/.local/bin/scripts/tmux-sessionizer\n"

[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# Per-machine and private config
# ---------------------------------------------------------------------------
[[ -r "${ZSH_CONFIG_DIR}/hosts/${DOTFILES_HOST}.zsh" ]] \
    && source "${ZSH_CONFIG_DIR}/hosts/${DOTFILES_HOST}.zsh"

# Untracked. Secrets, tokens, work-only paths, quick experiments.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
