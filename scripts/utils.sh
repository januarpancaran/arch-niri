#!/bin/bash

cmd_exists() {
    command -v "$1" &>/dev/null
}

sudo_cmd=""
aur_helper=""

if cmd_exists doas; then
    sudo_cmd="doas"
else
    sudo_cmd="sudo"
fi

install_aur_helper() {
    local helper="$1"
    local helper_dir=$(mktemp -d -t aur-helper-XXXXXX)

    "$sudo_cmd" pacman -Syu --noconfirm git
    git clone https://aur.archlinux.org/"${helper}".git "$helper_dir"
    (cd "$helper_dir" && makepkg -si --noconfirm)
    rm -rf "$helper_dir"
}

setup_aur_helper() {
    if cmd_exists yay; then
        aur_helper="yay"
    elif cmd_exists paru; then
        aur_helper="paru"
    else
        echo "No AUR Helper detected!"
        echo "Choose AUR Helper to install: [1 or 2]: "
        echo "1) yay"
        echo "2) paru"
        read -p "Enter your choice: [1 or 2]: " aur_choice

        case "$aur_choice" in
            1)
                echo "Installing yay..."
                install_aur_helper yay
                aur_helper="yay"
                ;;
            2)
                echo "Installing paru..."
                install_aur_helper paru
                aur_helper="paru"
                ;;
            *)
                echo "Invalid choice."
                exit 1
                ;;
        esac
    fi
}

install() {
    setup_aur_helper
    "$aur_helper" -S --noconfirm "$@"
}

set_config_dir() {
    conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
    mkdir -p "$conf_dir" 
}

backup_dir() {
    local dir="$1"
    [ -d "$dir" ] && mv -v "$dir" "${dir}.bak"
}

backup_file() {
    local file="$1"
    [ -f "$file" ] && mv -v "$file" "${file}.bak"
}

link_file() {
    local src="$1"
    local target="$2"

    mkdir -p "$(dirname $target)"
    
    ln -s "$src" "$target"
}

add_group() {
    "$sudo_cmd" usermod -aG "$1" $USER
}

enable_service() {
    "$sudo_cmd" systemctl enable "$@"
}

enable_user_service() {
    systemctl enable --user "$@"
}
