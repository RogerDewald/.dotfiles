#!/usr/bin/env bash
# Symlink these dotfiles into $HOME with GNU stow.
#
#   ./install.sh              # auto: base packages, plus desktop ones on X
#   ./install.sh base         # zsh, tmux, bin only (WSL / headless / server)
#   ./install.sh desktop      # base + i3, picom, polybar, background
#   ./install.sh zsh tmux     # exactly the packages named
#   DRY_RUN=1 ./install.sh    # show what stow would do, change nothing
#
# Stow is what decides which parts of the repo land on this machine — that is
# the job the old per-machine branches were doing badly.

set -euo pipefail

cd "$(dirname "$0")"

BASE=(zsh tmux bin)
DESKTOP=(i3 picom polybar background)

if ! command -v stow >/dev/null 2>&1; then
    echo "install.sh: GNU stow is not installed." >&2
    echo "  ./dependency_files/ubuntu-dependencies.sh" >&2
    exit 1
fi

case "${1:-auto}" in
    auto)
        packages=("${BASE[@]}")
        # No X and WSL both mean the i3 half is dead weight.
        if [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]] \
            && ! grep -qi microsoft /proc/version 2>/dev/null; then
            packages+=("${DESKTOP[@]}")
        fi
        ;;
    base)    packages=("${BASE[@]}") ;;
    desktop) packages=("${BASE[@]}" "${DESKTOP[@]}") ;;
    *)       packages=("$@") ;;
esac

echo "Stowing: ${packages[*]}"

stow_args=(--target="$HOME" --no-folding)
[[ -n "${DRY_RUN:-}" ]] && stow_args+=(--simulate --verbose)

for pkg in "${packages[@]}"; do
    if [[ ! -d "$pkg" ]]; then
        echo "  skip $pkg (no such package in this repo)" >&2
        continue
    fi
    echo "  $pkg"
    stow "${stow_args[@]}" "$pkg"
done

echo
echo "Done."
echo "Remember the two untracked, per-machine files (see README):"
echo "  ~/.config/zsh/host   one line naming this machine's host file"
echo "  ~/.zshrc.local       anything private or machine-only"
echo "The neovim config is a separate repo: RogerDewald/.nvimfiles"
