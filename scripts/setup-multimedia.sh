#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

MULTIMEDIA_PKGS=(
    discord
    mpv
    obs-studio
    spotify
    telegram-desktop
)

install_multimedia() {
    install "${MULTIMEDIA_PKGS[@]}"
}
