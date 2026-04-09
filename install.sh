#!/bin/bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
scripts_dir="$root_dir/scripts"

# imports
source "$scripts_dir/utils.sh"
source "$scripts_dir/setup-browser.sh"
source "$scripts_dir/setup-dev-packages.sh"
source "$scripts_dir/setup-fonts.sh"
source "$scripts_dir/setup-multimedia.sh"
source "$scripts_dir/setup-packages.sh"
source "$scripts_dir/setup-pipewire.sh"
source "$scripts_dir/setup-services.sh"
source "$scripts_dir/setup-theme.sh"

copy_configs() {
    echo "Copying config files..."

    set_config_dir

    local -a conf_dirs=(
        fastfetch
        ghostty
        mpv
        niri
        noctalia
        tmux
        starship
    )

    local -a home_files=(
        .bashrc
        .zshrc
    )

    for dir in "${conf_dirs[@]}"; do
        local src="$root_dir/src/$dir"
        [ -d "$src" ] || continue

        local dest="${conf_dir}/$dir"

        [ -e "$dest" ] && backup_dir "$dest"

        cp -r "$src" "$dest"
        echo "Copied $src -> $dest"
    done

    for file in "${home_files[@]}"; do
        local src="$root_dir/src/$file"
        [ -f "$src" ] || continue

        local dest="$HOME/$file"
        [ -f "$dest" ] && backup_file "$dest"

        cp "$src" "$dest"
        echo "Copied $src -> $dest"
    done
}

install_tmux_tpm() {
    set_config_dir

    local tpm_dir="${conf_dir}/tmux/plugins/tpm"

    mkdir -p "$(dirname "$tpm_dir")"

    [ ! -d "$tpm_dir" ] && git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

change_shell() {
    read -rp "Change shell to zsh? [y/N] " shell_choice

    case "$shell_choice" in
        [Yy])
            chsh -s "$(command -v zsh)"
            ;;
        *)
            echo "Shell not changed"
            ;;
    esac
}

main() {
    install_pkgs
    setup_sound
    enable_services
    install_fonts
    install_themes
    install_multimedia
    copy_configs
    install_tmux_tpm
    choose_browser

    user_choice "Development packages" install_dev_pkgs

    add_group video
    change_shell

    echo "Installation finished!"
}

main "$@"
