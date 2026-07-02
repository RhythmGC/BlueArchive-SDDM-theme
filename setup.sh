#!/bin/bash

## SDDM Blue Archive Theme Installer
## Based on original by RhythmGC https://github.com/RhythmGC/BlueArchive-SDDM-theme
## Copyright (C) 2026 RhythmGC

# Script works in Arch, Fedora, Ubuntu. Didn't tried in Void and openSUSE

set -euo pipefail

readonly THEME_NAME="BlueArchive-SDDM-theme"
readonly THEMES_DIR="/usr/share/sddm/themes"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly METADATA="$THEMES_DIR/$THEME_NAME/metadata.desktop"
readonly DATE=$(date +%s)

if [[ -f "$SCRIPT_DIR/source.json" ]]; then
    THEMES=($(grep -E '"[^"]+": \{' "$SCRIPT_DIR/source.json" | awk -F'"' '{print $2}'))
else
    THEMES=(
        "astronaut" "black_hole" "cyberpunk" "hyprland_kath" "jake_the_dog"
        "yuuka_hayase"
        "japanese_aesthetic" "pixel_sakura" "pixel_sakura_static"
        "post-apocalyptic_hacker" "purple_leaves"
    )
fi

# Logging with gum fallback
info() {
    if command -v gum &>/dev/null; then
        gum style --foreground 10 "✅ $*"
    else
        echo -e "\e[32m✅ $*\e[0m"
    fi
}

warn() {
    if command -v gum &>/dev/null; then
        gum style --foreground 11 "⚠  $*"
    else
        echo -e "\e[33m⚠  $*\e[0m"
    fi
}

error() {
    if command -v gum &>/dev/null; then
        gum style --foreground 9 "❌ $*" >&2
    else
        echo -e "\e[31m❌ $*\e[0m" >&2
    fi
}

# UI functions
confirm() {
    if command -v gum &>/dev/null; then
        gum confirm "$1"
    else
        echo -n "$1 (y/n): "; read -r r; [[ "$r" =~ ^[Yy]$ ]]
    fi
}

choose() {
    if command -v gum &>/dev/null; then
        gum choose --cursor.foreground 12 --header="" --header.foreground 12 "$@"
    else
        select opt in "$@"; do [[ -n "$opt" ]] && { echo "$opt"; break; }; done
    fi
}

spin() {
    local title="$1"; shift
    if command -v gum &>/dev/null; then
        gum spin --spinner="dot" --title="$title" -- "$@"
    else
        echo "$title"; "$@"
    fi
}

# Install gum if missing
install_gum() {
    local mgr=$(for m in pacman xbps-install dnf zypper apt; do command -v $m &>/dev/null && { echo $m; break; }; done)

    case $mgr in
        pacman) sudo pacman -S gum ;;
        dnf) sudo dnf install -y gum ;;
        zypper) sudo zypper install -y gum ;;
        xbps-install) sudo xbps-install -y gum ;;
        # refrence https://github.com/basecamp/omakub/issues/222
        apt)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt update && sudo apt install -y gum ;;
        *) error "Cannot install gum automatically"; return 1 ;;
    esac
}

# Check and install gum
check_gum() {
    if ! command -v gum &>/dev/null; then
        warn "Gum was not found - provides better UI experience"
        if confirm "Install gum?"; then
            install_gum && { info "Restarting with gum..."; main; } || warn "Using fallback UI"
        fi
    fi
}

# Install dependencies
install_deps() {
    local mgr=$(for m in pacman xbps-install dnf zypper apt; do command -v $m &>/dev/null && { echo $m; break; }; done)
    info "Package manager: $mgr"

    case $mgr in
        pacman) sudo pacman --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ;;
        xbps-install) sudo xbps-install -y sddm qt6-svg qt6-virtualkeyboard qt6-multimedia ;;
        dnf) sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia ;;
        zypper) sudo zypper install -y sddm libQt6Svg6 qt6-virtualkeyboard qt6-multimedia ;;
        apt) sudo apt update && sudo apt install -y sddm qt6-svg-dev qml6-module-qtquick-virtualkeyboard qt6-multimedia-dev ;;
        *) error "Unsupported package manager"; return 1 ;;
    esac
    info "Dependencies installed"
}

# Download media
download_media() {
    local theme="${1:-}"
    if [[ -z "$theme" ]]; then
        theme=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
    fi
    
    local json_file="$SCRIPT_DIR/source.json"
    local bg_dir="$SCRIPT_DIR/Backgrounds"
    local img_dir="$bg_dir/images"
    local vid_dir="$bg_dir/videos"
    
    if [[ ! -f "$json_file" ]]; then
        warn "source.json not found, skipping media download."
        return 0
    fi
    
    command -v jq &>/dev/null || { error "jq not installed. Please run Install Dependencies first."; return 1; }
    command -v curl &>/dev/null || { error "curl not installed. Please run Install Dependencies first."; return 1; }
    
    mkdir -p "$img_dir" "$vid_dir"
    info "Downloading media for $theme..."
    
    local video_url=$(jq -r ".\"$theme\".video // empty" "$json_file")
    local image_url=$(jq -r ".\"$theme\".image // empty" "$json_file")
    
    local conf_file="$SCRIPT_DIR/Themes/${theme}.conf"
    
    # Ensure conf file exists by copying yuuka_hayase.conf if necessary
    if [[ ! -f "$conf_file" && -f "$SCRIPT_DIR/Themes/yuuka_hayase.conf" ]]; then
        cp "$SCRIPT_DIR/Themes/yuuka_hayase.conf" "$conf_file"
    fi

    # Helper function to download using curl, bypass Pixiv 403
    download_file() {
        local url="$1"
        local out="$2"
        local extra_opts=()
        if [[ "$url" == *"pximg.net"* ]]; then
            extra_opts=(-H "Referer: https://www.pixiv.net/")
        fi
        curl -L -f -s "${extra_opts[@]}" "$url" -o "$out"
    }
    
    # If the video URL is actually a static image file, treat it as image only
    local is_video_static=false
    if [[ "$video_url" =~ \.(jpg|jpeg|png|webp|gif)$ ]]; then
        is_video_static=true
        if [[ -z "$image_url" ]]; then
            image_url="$video_url"
        fi
        video_url=""
    fi

    if [[ -n "$video_url" ]]; then
        local video_file="$vid_dir/${theme}.mp4"
        if [[ ! -f "$video_file" ]]; then
            spin "Downloading video for $theme..." download_file "$video_url" "$video_file"
        fi
        if [[ -f "$conf_file" ]]; then
            sed -i "s|^Background=.*|Background=\"Backgrounds/videos/${theme}.mp4\"|" "$conf_file"
        fi
    else
        # If no video is present, disable video background in config
        if [[ -f "$conf_file" ]]; then
            sed -i "s|^Background=.*|Background=\"Backgrounds/images/${theme}.jpg\"|" "$conf_file"
        fi
    fi
    
    if [[ -n "$image_url" ]]; then
        local image_file="$img_dir/${theme}.jpg"
        if [[ ! -f "$image_file" ]]; then
            spin "Downloading image for $theme..." download_file "$image_url" "$image_file"
        fi
        if [[ -f "$conf_file" ]]; then
            sed -i "s|^BackgroundPlaceholder=.*|BackgroundPlaceholder=\"Backgrounds/images/${theme}.jpg\"|" "$conf_file"
        fi
    fi
    info "Media downloaded and config updated for $theme."
    
    local dst="$THEMES_DIR/$THEME_NAME"
    if [[ -d "$dst" ]]; then
        sudo cp "$conf_file" "$dst/Themes/" 2>/dev/null || true
        sudo mkdir -p "$dst/Backgrounds/videos" "$dst/Backgrounds/images"
        [[ -f "$vid_dir/${theme}.mp4" ]] && sudo cp "$vid_dir/${theme}.mp4" "$dst/Backgrounds/videos/" 2>/dev/null || true
        [[ -f "$img_dir/${theme}.jpg" ]] && sudo cp "$img_dir/${theme}.jpg" "$dst/Backgrounds/images/" 2>/dev/null || true
    fi
}

# Install theme (with theme selection built-in)
install_theme() {
    local src="$SCRIPT_DIR"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$src" ]] && { error "Run this script from the theme directory"; return 1; }

    # --- Pick theme variant BEFORE installing ---
    info "Choose a theme variant to install:"
    local selected_theme=$(choose "${THEMES[@]}" || echo "yuuka_hayase")

    # Backup and copy
    [[ -d "$dst" ]] && sudo mv "$dst" "${dst}_$DATE"
    sudo mkdir -p "$dst"
    spin "Installing theme files..." sudo cp -r "$src"/* "$dst"/

    # Install fonts
    [[ -d "$dst/Fonts" ]] && spin "Installing fonts..." sudo cp -r "$dst/Fonts"/* /usr/share/fonts/

    # Configure SDDM
    echo "[Theme]
    Current=$THEME_NAME" | sudo tee /etc/sddm.conf > /dev/null

    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
    InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null

    info "Theme installed"

    # Download media and set selected theme
    download_media "$selected_theme"
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${selected_theme}.conf|" "$METADATA"
    info "Active theme set to: $selected_theme"
}

# Update theme files only (no backup, no reinstall — just sync changes)
update_theme() {
    local src="$SCRIPT_DIR"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$dst" ]] && { error "Theme not installed yet. Please run Install Theme first."; return 1; }

    spin "Updating theme files..." sudo cp -r "$src"/* "$dst"/
    info "Theme files updated ✅"

    # Ask if user wants to switch theme variant too
    if confirm "Switch theme variant as well?"; then
        local selected_theme=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
        download_media "$selected_theme"
        sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${selected_theme}.conf|" "$METADATA"
        info "Active theme set to: $selected_theme"
    fi
}

# Select theme variant
select_theme() {
    [[ ! -f "$METADATA" ]] && { error "Install theme first"; return 1; }
    
    local theme=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
    
    download_media "$theme"
    
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${theme}.conf|" "$METADATA"
    info "Selected theme: $theme"
}

# Enable SDDM
enable_sddm() {
    command -v systemctl &>/dev/null || { error "systemctl not found"; return 1; }

    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    info "SDDM enabled"
    warn "Reboot required"
}

preview_theme(){
    local log_file="/tmp/${THEME_NAME}_$DATE.txt"
    
    sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/BlueArchive-SDDM-theme/ > $log_file 2>&1 &
    greeter_pid=$!

    # wait for ten seconds
    for i in {1..10}; do
        if ! kill -0 "$greeter_pid" 2>/dev/null; then
            break
        fi
        sleep 1
    done

    if kill -0 "$greeter_pid" 2>/dev/null; then
        kill "$greeter_pid"
    fi


    local theme="$(sed -n 's|^ConfigFile=Themes/\(.*\)\.conf|\1|p' $METADATA)"
    info "Preview closed ($theme theme found)." 
    info "Log file: $log_file"
}

# Main menu
main() {
    [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }
    command -v git &>/dev/null || { error "git required"; exit 1; }

    check_gum
    clear
    while true; do
        if command -v gum &>/dev/null; then
            gum style --bold --padding "0 2" --border double --border-foreground 12 "🚀 Blue Archive SDDM Theme Installer"
        else
            echo -e "\e[36m🚀 Blue Archive SDDM Theme Installer\e[0m"
        fi

        local choice=$(choose \
            "🚀 Complete Installation (recommended)" \
            "📦 Install Dependencies" \
            "📥 Download Media" \
            "📂 Install Theme (choose variant)" \
            "🔄 Update Theme Files (quick sync)" \
            "🔧 Enable SDDM Service" \
            "🎨 Select Theme Variant" \
            "✨ Preview the set theme" \
            "❌ Exit")

        case "$choice" in
            "🚀 Complete Installation (recommended)") install_deps && install_theme && enable_sddm && info "Everything done!" && exit 0;;
            "📦 Install Dependencies") install_deps ;;
            "📥 Download Media") download_media ;;
            "📂 Install Theme (choose variant)") install_theme ;;
            "🔄 Update Theme Files (quick sync)") update_theme ;;
            "🔧 Enable SDDM Service") enable_sddm ;;
            "🎨 Select Theme Variant") select_theme ;;
            "✨ Preview the set theme") preview_theme;;
            "❌ Exit") info "Goodbye!"; exit 0 ;;
        esac

        echo; if command -v gum &>/dev/null; then
            gum input --placeholder="Press Enter to continue..."
        else
            echo -n "Press Enter to continue..."; read -r
        fi
    done
}

# trap 'echo; info "Cancelled"; exit 130' INT TERM
main "$@"
