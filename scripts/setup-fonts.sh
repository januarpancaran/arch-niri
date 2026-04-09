#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

FONTS=(
	noto-fonts-cjk
	noto-fonts-emoji
	ttf-jetbrains-mono-nerd
)

install_fonts() {
    install "${FONTS[@]}"
}
