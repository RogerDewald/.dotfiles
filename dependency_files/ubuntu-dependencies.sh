#!/usr/bin/env bash
# Install the apt packages these dotfiles expect, on Debian/Ubuntu/WSL.
#
#   ./dependency_files/ubuntu-dependencies.sh          # base only
#   ./dependency_files/ubuntu-dependencies.sh desktop  # base + i3 desktop
#
# Base is enough for WSL or a headless box. `desktop` adds the i3 / polybar /
# picom side and is pointless without an X session.
#
# Not installed here (each wants its own install method — see the README):
#   neovim (use the appimage or a PPA; distro nvim is usually too old),
#   ripgrep on older releases, go, nvm/node, rustup.

set -euo pipefail

BASE=(
    curl
    g++
    git
    unzip
    stow
    tmux
    zsh
    fzf
    ripgrep
    build-essential
    python3
    python3-pip
    npm
)

DESKTOP=(
    i3
    picom
    polybar
    feh
    dmenu
    rofi
    xclip
    maim
    xdotool
    copyq
    brightnessctl
    alsa-utils
    pulseaudio-utils
    network-manager
    network-manager-gnome
    blueman
    upower
    fonts-jetbrains-mono
    dex
    xss-lock
    i3lock
)

packages=("${BASE[@]}")
if [[ "${1:-}" == "desktop" ]]; then
    packages+=("${DESKTOP[@]}")
fi

SUDO=""
if [[ $EUID -ne 0 ]]; then
    SUDO="sudo"
fi

$SUDO apt-get update
# One call, not one per package: apt resolves the set together, and a single
# missing name no longer silently skips everything after it.
$SUDO apt-get install -y "${packages[@]}"

echo
echo "Done. Still to do by hand:"
echo "  - neovim      https://neovim.io  (needs >= 0.10 for this config)"
echo "  - nvm/node    https://github.com/nvm-sh/nvm"
echo "  - oh-my-zsh   https://ohmyz.sh"
echo "  - a Nerd Font (JetBrainsMono NL) if the polybar/i3 glyphs look wrong"
