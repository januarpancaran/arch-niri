#!/bin/bash

cmd_exists() {
  command -v "$1" &> /dev/null
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
  if [ -d "$dir" ]; then
    mv -v "$dir" "${dir}.bak"
  fi
  return 0
}

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    mv -v "$file" "${file}.bak"
  fi
  return 0
}

link_file() {
  local src="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] && [ "$target" -ef "$src" ]; then
    return 0
  fi

  if [ -L "$target" ]; then
    rm -f "$target"
  elif [ -d "$target" ]; then
    backup_dir "$target"
  elif [ -e "$target" ]; then
    backup_file "$target"
  fi

  ln -s "$src" "$target"
}

add_group() {
  local group_name="$1"
  local target_user="${SUDO_USER:-${USER:-}}"

  if [ -z "$target_user" ]; then
    target_user="$(id -un)"
  fi

  "$sudo_cmd" usermod -aG "$group_name" "$target_user"
}

enable_service() {
  "$sudo_cmd" systemctl enable "$@"
}

enable_user_service() {
  systemctl enable --user "$@"
}

user_choice() {
  local label="$1"
  shift

  read -rp "Install optional ${label}? [y/N] " choice

  case "$choice" in
  [Yy])
    echo "Installing ${label}..."
    "$@"
    ;;
  *)
    echo "Skipping ${label}"
    ;;
  esac
}
