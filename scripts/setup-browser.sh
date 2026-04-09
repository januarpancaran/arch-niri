#!/bin/bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/utils.sh"

is_chromium=false

browser_config() {
    local browser_cmd="$1"
    local private_arg="$2"

    set_config_dir

    local niri_scripts_dir="$conf_dir/niri/scripts"

    [ ! -d "$niri_scripts_dir" ] && mkdir -p "$niri_scripts_dir"

    local conf_file="$niri_scripts_dir/browser.conf"

    cat > "$conf_file" << EOF
BROWSER_CMD="$browser_cmd"
BROWSER_PRIVATE_ARG="$private_arg"
EOF

    echo "Saved browser config to $conf_file"

}

chromium_launch_args() {
    local chromium_browser="$1"
    local launch_args_file=""

    if [ "$chromium_browser" = "chrome" ]; then
        launch_args_file="$conf_dir/chrome-flags.conf"
    else
        launch_args_file="$conf_dir/microsoft-edge-stable-flags.conf"
    fi

    backup_file "$launch_args_file"

    cat > "$launch_args_file" << EOF
--enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation 
--ozone-platform=wayland"
EOF

    echo "Saved launch args to $launch_args_file"
}

choose_browser() {
    echo "Choose your preferred browser from this list"
    echo "1) Firefox"
    echo "2) Zen Browser"
    echo "3) Google Chrome"
    echo "4) Microsoft Edge"

    read -rp "Enter your choice: " browser_choice

    case "$browser_choice" in
        1)
            echo "Installing firefox..."
            install firefox
            browser_config "firefox" "--private-window"
            ;;
        2)
            echo "Installing zen browser..."
            install zen-browser-bin
            browser_config "zen" "--private-window"
            ;;
        3)
            echo "Installing google chrome..."
            install google-chrome
            browser_config "google-chrome-stable" "--incognito"
            chromium_launch_args chrome
            ;;
        4)
            echo "Installing microsoft edge..."
            install microsoft-edge-stable-bin
            browser_config "microsoft-edge-stable" "--inprivate"
            chromium_launch_args edge
            ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac
}

choose_browser
