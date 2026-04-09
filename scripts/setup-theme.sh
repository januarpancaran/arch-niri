#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

THEMES=(
    bibata-cursor-theme-bin
    dracula-gtk-theme
)

install_tela_icons() {
    local repo_dir="/tmp/tela-icon-theme"
    if ! git clone --depth=1 https://github.com/vinceliuice/tela-icon-theme "$repo_dir"; then
        echo "Failed to clone Tela icon theme"
        return 1
    fi

    local icons_dir="$HOME/.icons"

    mkdir -p "$icons_dir"
    if ! "$repo_dir/install.sh" nord -d "$icons_dir"; then
        echo "Failed to install Tela icons"
        rm -rf "$repo_dir"
        return 1
    fi
    rm -rf "$repo_dir"
}

install_themes() {
    install "${THEMES[@]}"

    install_tela_icons

    set_config_dir

    local gtk4_dir="$conf_dir/gtk-4.0"

    mkdir -p "$gtk4_dir"

    link_file "/usr/share/themes/Dracula/gtk-4.0/gtk.css" "$gtk4_dir/gtk.css"
    link_file "/usr/share/themes/Dracula/gtk-4.0/gtk-dark.css" "$gtk4_dir/gtk-dark.css"
    link_file "/usr/share/themes/Dracula/gtk-4.0/assets" "$gtk4_dir/assets"
}
