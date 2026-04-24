#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

PKGS=(
  acpi
  bat
  bluez
  bluez-utils
  brightnessctl
  cloudflare-warp-bin
  curl
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
  loupe
  man-db
  nautilus
  niri
  noctalia-shell
  ntfs-3g
  openssh
  os-prober
  papers
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
  wlsunset
  xdg-desktop-portal-gnome
  xdg-desktop-portal-gtk
  xorg-xhost
  xwayland-satellite
  yazi
  zip
  zoxide
  zsh
)

install_pkgs() {
  install "${PKGS[@]}"
}
