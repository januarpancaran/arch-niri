#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

DEV_PKGS=(
    aspnet-runtime
    aspnet-targeting-pack
    bun
    composer
    dotnet-sdk
    gcc
    github-cli
    github-copilot-cli
    go
    jdk-openjdk
    neovim
    nodejs
    opencode
    php
    python
    ruby
    rust
    sqlite
    visual-studio-code-bin
)

setup_mariadb() {
    install mariadb
    "$sudo_cmd" mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    enable_service mariadb
}

setup_postgres() {
    install postgresql
    "$sudo_cmd" -u postgres initdb --auth-local=peer --auth-host=scram-sha-256 -D /var/lib/postgres/data
    enable_service postgresql
}

setup_docker() {
    install docker docker-compose docker-buildx
    enable_service docker
    add_group docker
}

setup_vscode() {
    set_config_dir

    local launch_args_file="$conf_dir/code-flags.conf"

    backup_file "$launch_args_file"

    cat > "$launch_args_file" << EOF
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOF

    echo "Saved vscode launch args to $launch_args_file"
}

install_dev_pkgs() {
    install "${DEV_PKGS[@]}"

    setup_mariadb
    setup_postgres
    setup_docker
    setup_vscode
}
