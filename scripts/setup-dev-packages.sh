#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

DEV_PKGS=(
  aspnet-runtime
  aspnet-targeting-pack
  bun
  composer
  dotnet-sdk
  dotnet-runtime
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
  python-pip
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
  local data_dir="/var/lib/postgres/data"

  install postgresql

  if "$sudo_cmd" test -f "$data_dir/PG_VERSION"; then
    echo "PostgreSQL is already initialized at $data_dir, skipping initdb"
  elif "$sudo_cmd" test -d "$data_dir" && "$sudo_cmd" sh -c "[ -n \"\$(ls -A '$data_dir' 2>/dev/null)\" ]"; then
    echo "Skipping PostgreSQL initdb: $data_dir exists and is not empty"
    echo "Clean $data_dir if you want to reinitialize PostgreSQL"
  else
    "$sudo_cmd" -u postgres initdb --auth-local=peer --auth-host=scram-sha-256 -D "$data_dir"
  fi

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

setup_npm() {
  local npm_prefix="$HOME/.local/npm-global"

  if ! cmd_exists npm; then
    echo "npm not found, skipping npm setup"
    return 0
  fi

  mkdir -p "$npm_prefix"
  npm config set prefix "$npm_prefix"

  echo "Configured npm global prefix at $npm_prefix"
}

install_dev_pkgs() {
  install "${DEV_PKGS[@]}"

  setup_mariadb
  setup_postgres
  setup_docker
  setup_vscode
  setup_npm
}
