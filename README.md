# BlueArchive-SDDM-theme

![Stars](https://img.shields.io/github/stars/RhythmGC/BlueArchive-SDDM-theme?color=5d8aa8&labelColor=1b1b25&style=for-the-badge)
![Forks](https://img.shields.io/github/forks/RhythmGC/BlueArchive-SDDM-theme?color=bf616a&labelColor=1b1b25&style=for-the-badge)

**BlueArchive-SDDM-theme** is a modern, high-quality, and highly customizable series of themes for the [SDDM](https://github.com/sddm/sddm/) display manager. Designed and maintained by **[RhythmGC](https://github.com/RhythmGC)**, it features premium Qt6 visuals, virtual keyboard support, and an automated script that dynamically downloads and applies animated video/image backgrounds from `source.json`.

---

## 🚀 Key Features

*   **Beautiful Animations:** Native support for high-definition video backgrounds (`.mp4`, `.webm`) and static fallback images.
*   **Dynamic Theme Installer (`setup.sh`):** An interactive installer that reads configured themes from `source.json` and manages everything automatically.
*   **Virtual Keyboard Integration:** Fully supported virtual keyboard for touchscreen or accessibility use.
*   **Lightweight & Modern:** Developed using the latest **Qt6** standards for optimal performance.

---

## 📦 Requirements & Dependencies

Before installation, ensure you have the required Qt6 libraries. The installer script can automatically fetch these for you on supported package managers.

*   `sddm >= 0.21.0`
*   `qt6-svg`
*   `qt6-virtualkeyboard`
*   `qt6-multimedia` (and `qt6-multimedia-ffmpeg` for video playback)
*   `jq` & `curl` (for reading configurations and downloading assets)

---

## 🛠️ Installation

### Option 1: Automatic Interactive Installer (Recommended)

Simply clone this repository locally, move into the directory, and run the automated installer:

```bash
git clone https://github.com/RhythmGC/BlueArchive-SDDM-theme.git
cd BlueArchive-SDDM-theme
chmod +x setup.sh
./setup.sh
```

#### Installer Menu Options:
1.  **🚀 Complete Installation (recommended):** Installs all dependencies, prompts you to select your preferred theme, automatically downloads its background media, sets up configurations, and enables SDDM.
2.  **📦 Install Dependencies:** Automatically installs Qt6 packages, `jq`, and `curl` using your system package manager.
3.  **📥 Download Media:** Choose a specific theme to download its video/image background files and configure it.
4.  **📂 Install Theme:** Copies theme assets to system directories and configures SDDM.
5.  **🎨 Select Theme Variant:** Interactively choose which configuration variant to use.
6.  **✨ Preview the set theme:** Tests the selected SDDM screen without logging out.

---

### Option 2: Manual Installation

1.  **Install dependencies** on your distribution:
    ```bash
    # Arch Linux
    sudo pacman -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg jq curl
    
    # Fedora
    sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia jq curl
    ```
2.  **Clone the repository** to SDDM themes directory:
    ```bash
    sudo git clone https://github.com/RhythmGC/BlueArchive-SDDM-theme.git /usr/share/sddm/themes/BlueArchive-SDDM-theme
    ```
3.  **Copy the Fonts:**
    ```bash
    sudo cp -r /usr/share/sddm/themes/BlueArchive-SDDM-theme/Fonts/* /usr/share/fonts/
    ```
4.  **Set as Current Theme:**
    Edit `/etc/sddm.conf` to use `BlueArchive-SDDM-theme`:
    ```ini
    [Theme]
    Current=BlueArchive-SDDM-theme
    ```
5.  **Enable Virtual Keyboard:**
    Create `/etc/sddm.conf.d/virtualkbd.conf`:
    ```ini
    [General]
    InputMethod=qtvirtualkeyboard
    ```

---

## ⚙️ Customizing Themes with `source.json`

You can easily add new characters, themes, or custom background elements by editing the local `source.json` file in the root directory.

### 1. Structure of `source.json`
Add a new JSON object for your theme with the direct URLs to the background video and thumbnail/fallback image:

```json
{
    "yuuka_hayase": {
        "video": "https://res.cloudinary.com/.../Yuuka_d8qnc0.mp4",
        "image": "https://res.cloudinary.com/.../GTA5An8bUAAsHLp_zg6ptz.jpg"
    },
    "your_custom_theme": {
        "video": "https://your-domain.com/background.mp4",
        "image": "https://your-domain.com/fallback.jpg"
    }
}
```

### 2. Tải về và cấu hình (Apply)
*   Run the script: `./setup.sh`
*   Select **🎨 Select Theme Variant** or **📥 Download Media**.
*   Select your custom theme name from the interactive UI.
*   The script will automatically:
    1.  Create `Backgrounds/images/` and `Backgrounds/videos/` folders if they do not exist.
    2.  Download files to `Backgrounds/images/your_custom_theme.jpg` and `Backgrounds/videos/your_custom_theme.mp4`.
    3.  Generate or update `Themes/your_custom_theme.conf` with the correct relative paths.
    4.  Copy files to system theme directories.

---

## 🎨 Theme Preview

You can preview your selected theme live without signing out by running:
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/BlueArchive-SDDM-theme/
```
*(Press `Ctrl + C` in terminal to exit the preview greeter)*

---

## 📝 License & Copyright

*   Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.
*   Copyright (C) 2026 **[RhythmGC](https://github.com/RhythmGC)**.
*   Originally based on [MarianArlt's sugar-dark](https://github.com/MarianArlt/sddm-sugar-dark) layout concepts.
