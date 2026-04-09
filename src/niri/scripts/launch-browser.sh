#!/bin/bash
set -e

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
CONF_FILE="$CONF_DIR/niri/scripts/browser.conf"

if [ ! -f "$CONF_FILE" ]; then
  echo "Browser config not found at $CONF_FILE" >&2
  echo "Run scripts/setup-browser.sh first." >&2
  exit 1
fi

source "$CONF_FILE"

if [ -z "${BROWSER_CMD:-}" ]; then
  echo "BROWSER_CMD is not set in $CONF_FILE" >&2
  exit 1
fi

if [ "${1:-}" = "incognito" ] && [ -n "${BROWSER_PRIVATE_ARG:-}" ]; then
  exec "$BROWSER_CMD" "$BROWSER_PRIVATE_ARG"
fi

exec "$BROWSER_CMD"
