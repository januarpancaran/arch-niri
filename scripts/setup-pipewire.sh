#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

SOUND_PKGS=(
  alsa-firmware
  alsa-utils
  pipewire
  pipewire-alsa
  pipewire-pulse
  wireplumber
)

setup_sound() {
  install "${SOUND_PKGS[@]}"

  enable_user_service pipewire
}
