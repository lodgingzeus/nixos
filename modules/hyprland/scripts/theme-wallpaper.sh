#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="/home/deepak/wallpapers"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
wallpaper_cache="$cache_dir/current-wallpaper"
colors_cache="$cache_dir/wallpaper-colors.env"
lock_config="$cache_dir/hyprlock-dynamic.conf"
hyprpaper_config="$cache_dir/hyprpaper.conf"
log_file="$cache_dir/theme-wallpaper.log"

mkdir -p "$wallpaper_dir" "$cache_dir"
exec >>"$log_file" 2>&1

echo "[$(date --iso-8601=seconds)] theme-wallpaper start"

make_default_wallpaper() {
  local fallback="$cache_dir/default-wallpaper.png"

  if [[ ! -f "$fallback" ]]; then
    magick -size 2560x1440 gradient:"#191724-#1f3b4d" \
      -fill "#ebbcba22" -draw "circle 520,280 1180,940" \
      -fill "#9ccfd822" -draw "circle 2120,1080 1520,540" \
      -fill "#c4a7e71a" -draw "circle 1360,720 1700,1060" \
      -blur 0x28 "$fallback"
  fi

  printf '%s\n' "$fallback"
}

pick_wallpaper() {
  local chosen

  chosen="$(
    find "$wallpaper_dir" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
      | shuf -n 1
  )"

  if [[ -n "$chosen" ]]; then
    printf '%s\n' "$chosen"
  else
    make_default_wallpaper
  fi
}

hex_to_rgb() {
  local hex="${1#\#}"
  printf '%d %d %d\n' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

rgb_to_hex() {
  printf '%02x%02x%02x\n' "$1" "$2" "$3"
}

clamp_channel() {
  local value="$1"
  if (( value < 0 )); then
    printf '0'
  elif (( value > 255 )); then
    printf '255'
  else
    printf '%d' "$value"
  fi
}

mix_hex() {
  local a="$1" b="$2" percent="$3"
  local ar ag ab br bg bb rr rg rb
  read -r ar ag ab < <(hex_to_rgb "$a")
  read -r br bg bb < <(hex_to_rgb "$b")

  rr="$(clamp_channel $(((ar * (100 - percent) + br * percent) / 100)))"
  rg="$(clamp_channel $(((ag * (100 - percent) + bg * percent) / 100)))"
  rb="$(clamp_channel $(((ab * (100 - percent) + bb * percent) / 100)))"

  rgb_to_hex "$rr" "$rg" "$rb"
}

accent_from_wallpaper() {
  local wallpaper="$1"
  local color

  color="$(
    magick "$wallpaper" -resize 96x96\! -colors 8 -depth 8 -format '%c' histogram:info:- \
      | sort -nr \
      | sed -n '2s/.*#\([0-9A-Fa-f]\{6\}\).*/\1/p' \
      | head -n 1
  )"

  if [[ -n "$color" ]]; then
    printf '%s\n' "${color,,}"
  else
    magick "$wallpaper" -resize 1x1\! -depth 8 -format '%[hex:u.p{0,0}]' info:- | cut -c1-6 | tr 'A-F' 'a-f'
  fi
}

write_lock_config() {
  local wallpaper="$1" accent="$2" secondary="$3" base="$4" panel="$5" text="$6" muted="$7" danger="$8"

  cat > "$lock_config" <<EOF
general {
    disable_loading_bar = true
    hide_cursor = true
    ignore_empty_input = true
}

animations {
    enabled = true
    bezier = easeOutExpo, 0.16, 1, 0.3, 1
    bezier = softSettle, 0.05, 0.7, 0.1, 1
    fade_in {
        duration = 280
        bezier = easeOutExpo
    }
    fade_out {
        duration = 180
        bezier = easeOutExpo
    }
    inputFieldColors {
        duration = 180
        bezier = softSettle
    }
}

background {
    monitor =
    path = $wallpaper
    color = rgba(${base}ff)
    blur_passes = 5
    blur_size = 9
    noise = 0.012
    contrast = 0.94
    brightness = 0.58
    vibrancy = 0.24
    vibrancy_darkness = 0.52
}

shape {
    monitor =
    size = 620, 252
    position = 0, -8
    halign = center
    valign = center
    color = rgba(${panel}d8)
    rounding = 24
    border_size = 1
    border_color = rgba(${accent}88)
    shadow_passes = 3
    shadow_size = 24
    shadow_color = rgba(00000070)
}

shape {
    monitor =
    size = 620, 3
    position = 0, 118
    halign = center
    valign = center
    color = rgba(${secondary}dd)
    rounding = 2
}

label {
    monitor =
    text = cmd[update:1000] date +"%H:%M"
    position = 0, 68
    halign = center
    valign = center
    color = rgba(${text}f2)
    font_family = Inter
    font_size = 58
    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(00000066)
}

label {
    monitor =
    text = cmd[update:60000] date +"%A, %d %B"
    position = 0, 15
    halign = center
    valign = center
    color = rgba(${secondary}f0)
    font_family = Inter
    font_size = 15
}

label {
    monitor =
    text = cmd[update:30000] bash -lc 'printf "Battery %s  |  %s" "\$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)%" "\$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '\''\$1=="yes"{print \$2; exit}'\'' || true)"'
    position = 0, -92
    halign = center
    valign = center
    color = rgba(${muted}e8)
    font_family = Inter
    font_size = 13
}

label {
    monitor =
    text = Welcome back, Deepak
    position = 0, -65
    halign = center
    valign = center
    color = rgba(${text}df)
    font_family = Inter
    font_size = 13
}

input-field {
    monitor =
    size = 300, 48
    position = 0, -12
    halign = center
    valign = center
    dots_center = true
    dots_rounding = -1
    dots_size = 0.2
    dots_spacing = 0.28
    fade_on_empty = false
    font_color = rgba(${text}ff)
    inner_color = rgba(${base}dd)
    outer_color = rgba(${accent}cc)
    check_color = rgba(${secondary}ff)
    fail_color = rgba(${danger}ff)
    outline_thickness = 2
    rounding = 17
    placeholder_text = <span foreground="#${muted}">Password</span>
    fail_text = <span foreground="#${danger}">Nope, try again</span>
    shadow_passes = 2
    shadow_size = 12
    shadow_color = rgba(00000050)
}
EOF
}

wallpaper="${1:-$(pick_wallpaper)}"

if [[ ! -f "$wallpaper" ]]; then
  wallpaper="$(make_default_wallpaper)"
fi

cat > "$hyprpaper_config" <<EOF
preload = $wallpaper
wallpaper = ,$wallpaper
splash = false
EOF

if ! pgrep -x hyprpaper >/dev/null 2>&1; then
  hyprpaper --config "$hyprpaper_config" &
fi

for _ in {1..20}; do
  if hyprctl hyprpaper listloaded >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

hyprctl hyprpaper wallpaper ",$wallpaper"

accent="$(accent_from_wallpaper "$wallpaper")"
secondary="$(mix_hex "$accent" "f6c177" 45)"
base="$(mix_hex "$accent" "05070a" 82)"
panel="$(mix_hex "$accent" "0b0d12" 76)"
text="$(mix_hex "$accent" "f7f3ff" 88)"
muted="$(mix_hex "$accent" "908caa" 68)"
danger="eb6f92"

hyprctl keyword general:col.active_border "rgba(${accent}ee) rgba(${secondary}ee) 45deg" >/dev/null || true
hyprctl keyword general:col.inactive_border "rgba(${text}1f)" >/dev/null || true
hyprctl keyword decoration:shadow:color "rgba(${base}bb)" >/dev/null || true

printf '%s\n' "$wallpaper" > "$wallpaper_cache"
cat > "$colors_cache" <<EOF
WALLPAPER=$wallpaper
ACCENT=$accent
SECONDARY=$secondary
BASE=$base
PANEL=$panel
TEXT=$text
MUTED=$muted
DANGER=$danger
EOF

write_lock_config "$wallpaper" "$accent" "$secondary" "$base" "$panel" "$text" "$muted" "$danger"

echo "[$(date --iso-8601=seconds)] applied wallpaper: $wallpaper"
