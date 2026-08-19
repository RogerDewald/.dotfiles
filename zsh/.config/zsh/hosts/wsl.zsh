# WSL (Ubuntu under Windows). Auto-selected via /proc/version, so this
# file needs no ~/.config/zsh/host entry.

# Jump to the Windows side
alias windows="cd /mnt/c/Users/danie/Documents"
alias school="cd /mnt/c/Users/danie/Documents/School/OU/junior25/"
alias projects="cd /mnt/c/Users/danie/Documents/Personal/Projects/"
alias darkstar="cd /mnt/c/Users/danield/Documents/Projects/Darkstar"

# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# Rust — guarded so the shell still starts on a box without rustup
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Needed by the tree-sitter parsers built from source under WSL
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
