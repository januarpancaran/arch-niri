#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

SERVICES=(
  NetworkManager
  bluetooth
  gdm
  power-profiles-daemon
  warp-svc
)

enable_services() {
  enable_service "${SERVICES[@]}"
}
