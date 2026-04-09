#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

PKGS=(
  acpi
  bat
  bluez
  bluez-utils
  brightnessctl
  curl
  cloudflare-warp-bin
  fastfetch
  fzf
  gdm
  ghostty
  git
  gnome-keyring
  gvfs
  htop
  jq
  less
  man-db
  nautilus
  ntfs-3g
  openssh
  os-prober
  polkit-gnome
  power-profiles-daemon
  ripgrep
  starship
  tar
  tmux
  trash-cli
  tree
  unrar
  unzip
  wget
  wl-clipboard
  wl-mirror
  xdg-desktop-portal-gnome
  xdg-desktop-portal-gtk
  xwayland-satellite
  niri
  noctalia-shell
  xorg-xhost
  yazi
  zip
  zoxide
  zsh
)

install_pkgs() {
  install "${PKGS[@]}"
}
