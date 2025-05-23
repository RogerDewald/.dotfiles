#!/usr/bin/env bash

packages=(
    tmux
    zsh
)

for package in ${packages[@]}; do
    apt-get install ${package}
done
