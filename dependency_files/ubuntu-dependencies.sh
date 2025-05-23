#!/usr/bin/env bash

packages=(
    tmux
    zsh
    stow
)

for package in ${packages[@]}; do
    apt-get install ${package}
done
