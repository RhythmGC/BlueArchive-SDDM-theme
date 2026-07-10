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

# Apply color preset based on selected variant
apply_color_preset() {
    local variant="${1:-}"
    local conf="$SCRIPT_DIR/theme.conf"
    
    if [[ ! -f "$conf" ]]; then
        return 0
    fi
    
    local primary="" onPrimary="" surface="" surfaceContainer="" onSurface="" onSurfaceVariant="" bg="" error=""
    
    case "$variant" in
        yuuka_hayase)
            primary="#b4d8ff"
            onPrimary="#242455"
            surface="#1b1c32"
            surfaceContainer="#242455"
            onSurface="#b4d8ff"
            onSurfaceVariant="#8faadc"
            bg="#121226"
            error="#ff5e85"
            ;;
        bluearchiveOS)
            primary="#38BDF8"
            onPrimary="#121625"
            surface="#1e293b"
            surfaceContainer="#121625"
            onSurface="#ffffff"
            onSurfaceVariant="#81C7F5"
            bg="#121625"
            error="#FF5E85"
            ;;
        *)
            # Catppuccin Mocha defaults
            primary="#cba6f7"
            onPrimary="#1e1e2e"
            surface="#1e1e2e"
            surfaceContainer="#181825"
            onSurface="#cdd6f4"
            onSurfaceVariant="#9399b2"
            bg="#1e1e2e"
            error="#f38ba8"
            ;;
    esac
    
    # Use sed to replace keys in theme.conf
    sed -i "s|^primaryColor=.*|primaryColor=$primary|" "$conf"
    sed -i "s|^onPrimaryColor=.*|onPrimaryColor=$onPrimary|" "$conf"
    sed -i "s|^surfaceColor=.*|surfaceColor=$surface|" "$conf"
    sed -i "s|^surfaceContainerColor=.*|surfaceContainerColor=$surfaceContainer|" "$conf"
    sed -i "s|^onSurfaceColor=.*|onSurfaceColor=$onSurface|" "$conf"
    sed -i "s|^onSurfaceVariantColor=.*|onSurfaceVariantColor=$onSurfaceVariant|" "$conf"
    sed -i "s|^backgroundColor=.*|backgroundColor=$bg|" "$conf"
    sed -i "s|^errorColor=.*|errorColor=$error|" "$conf"
}

# Download media
download_media() {
    local theme_media="${1:-}"
    
    if [[ -z "$theme_media" ]]; then
        info "Choose a theme media variant to download:"
        theme_media=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
    fi
    
    local json_file="$SCRIPT_DIR/source.json"
    
    if [[ ! -f "$json_file" ]]; then
        warn "source.json not found, skipping media download."
        return 0
    fi
    
    command -v jq &>/dev/null || { error "jq not installed. Please run Install Dependencies first."; return 1; }
    command -v curl &>/dev/null || { error "curl not installed. Please run Install Dependencies first."; return 1; }
    
    local assets_dir="$SCRIPT_DIR/assets"
    mkdir -p "$assets_dir"
    
    info "Downloading media for $theme_media..."
    local image_url=$(jq -r ".\"$theme_media\".image // empty" "$json_file")
    
    if [[ -n "$image_url" ]]; then
        local image_file="$assets_dir/background.png"
        rm -f "$image_file"
        
        local extra_opts=()
        if [[ "$image_url" == *"pximg.net"* ]]; then
            extra_opts=(-H "Referer: https://www.pixiv.net/")
        fi
        spin "Downloading image for $theme_media..." curl -L -f -s "${extra_opts[@]}" "$image_url" -o "$image_file"
        
        # Apply the matching color preset
        apply_color_preset "$theme_media"
    else
        error "No image URL found for $theme_media in source.json"
        return 1
    fi
    
    info "Media downloaded and color preset applied for $theme_media."
    
    # Sync to system path if theme is installed
    local dst="$THEMES_DIR/$THEME_NAME"
    if [[ -d "$dst" ]]; then
        sudo mkdir -p "$dst/assets"
        sudo cp "$image_file" "$dst/assets/background.png"
        sudo cp "$SCRIPT_DIR/theme.conf" "$dst/theme.conf"
        info "Synced changes to system directory: $dst"
    fi
}

# Install theme
install_theme() {
    local src="$SCRIPT_DIR"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$src" ]] && { error "Run this script from the theme directory"; return 1; }

    # --- Pick variant BEFORE installing ---
    info "Choose a theme variant to use (background and colors):"
    local selected_media=$(choose "${THEMES[@]}" || echo "yuuka_hayase")

    # Download media and apply color preset locally first
    download_media "$selected_media"

    # Backup existing installation if present
    [[ -d "$dst" ]] && sudo mv "$dst" "${dst}_$DATE"
    sudo mkdir -p "$dst"
    
    # Copy all files to installation destination
    spin "Installing theme files..." sudo cp -r "$src"/* "$dst"/

    # Install fonts to system fonts folder (using lowercase fonts/)
    if [[ -d "$dst/fonts" ]]; then
        spin "Installing fonts..." sudo cp -r "$dst/fonts"/* /usr/share/fonts/
    fi

    # Configure SDDM Current Theme
    echo "[Theme]
Current=$THEME_NAME" | sudo tee /etc/sddm.conf > /dev/null

    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null

    setup_user_avatar

    info "Theme installed successfully ✅"
    info "Active variant set to: $selected_media"
}

# Setup user avatar for SDDM
setup_user_avatar() {
    local username="${SUDO_USER:-$USER}"
    local face_file=""
    
    if [[ -f "/home/$username/.face.icon" ]]; then
        face_file="/home/$username/.face.icon"
    elif [[ -f "/home/$username/.face" ]]; then
        face_file="/home/$username/.face"
    fi

    if [[ -n "$face_file" ]]; then
        spin "Setting up user avatar for SDDM..." sudo mkdir -p /usr/share/sddm/faces
        sudo cp "$face_file" "/usr/share/sddm/faces/$username.face.icon"
        sudo chmod 644 "/usr/share/sddm/faces/$username.face.icon"
        info "User avatar configured successfully ✅"
    else
        warn "No ~/.face or ~/.face.icon found in /home/$username/"
    fi
}

# Enable SDDM Service
enable_sddm() {
    spin "Enabling SDDM service..." sudo systemctl enable sddm
    info "SDDM service enabled ✅"
}

# Update theme files only (no backup, no reinstall — just sync changes)
update_theme() {
    local src="$SCRIPT_DIR"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$dst" ]] && { error "Theme not installed yet. Please run Install Theme first."; return 1; }

    spin "Updating theme files..." sudo cp -r "$src"/* "$dst"/
    
    # Install fonts if updated
    if [[ -d "$dst/fonts" ]]; then
        sudo cp -r "$dst/fonts"/* /usr/share/fonts/
    fi
    
    setup_user_avatar
    
    info "Theme files updated ✅"

    if confirm "Switch media variant as well?"; then
        info "Choose a theme variant to use:"
        local selected_media=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
        download_media "$selected_media"
    fi
}

# Select theme variant
select_theme() {
    [[ ! -f "$METADATA" ]] && { error "Install theme first"; return 1; }
    
    info "Choose a theme variant to use:"
    local selected_media=$(choose "${THEMES[@]}" || echo "yuuka_hayase")
    
    download_media "$selected_media"
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
