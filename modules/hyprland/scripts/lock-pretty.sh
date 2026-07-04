#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
lock_config="$cache_dir/hyprlock-dynamic.conf"
theme_script="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/theme-wallpaper"

if [[ ! -f "$lock_config" ]]; then
  "$theme_script"
fi

pidof hyprlock >/dev/null 2>&1 || hyprlock --config "$lock_config"
