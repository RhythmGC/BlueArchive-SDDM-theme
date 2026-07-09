# 🔹 Blue Archive SDDM Theme

![Stars](https://img.shields.io/github/stars/RhythmGC/BlueArchive-SDDM-theme?color=5d8aa8&labelColor=1b1b25&style=for-the-badge&t=1783601688)
![Forks](https://img.shields.io/github/forks/RhythmGC/BlueArchive-SDDM-theme?color=bf616a&labelColor=1b1b25&style=for-the-badge&t=1783601688)

> **Welcome back, Sensei! Access your Schale Terminal in Kivotos with style.** 

**BlueArchive-SDDM-theme** is a modern, premium, and highly customizable SDDM login interface themed after the popular game **Blue Archive**. Designed and developed by **[RhythmGC](https://github.com/RhythmGC)**, it transforms your standard Linux display manager into an operating Schale terminal, welcoming you with animated live background videos and static illustrations of your beloved students (e.g., Yuuka Hayase). All student database references and media assets are managed dynamically using `source.json`.

---

## 🚀 Key Features

*   🌸 **Live Student Animations:** Native support for high-definition student videos (L2D, animated backgrounds, `.mp4`, `.webm`) and static illustrations.
*   📂 **Schale Dynamic Installer (`setup.sh`):** An interactive assistant script that parses students configured in `source.json`, downloads their L2D assets, and configures the login environment automatically.
*   🎹 **Arona Assist (Virtual Keyboard):** Integrated virtual keyboard for touchscreen support and ease of access.
*   ⚡ **Kivotos Core Engine:** Powered by Qt6 and SDDM >= 0.21.0 for rapid, lightweight, and modern performance.

---

## 📦 Requirements & Dependencies

Before boot-up, ensure your system has the following Qt6 libraries. The installer script can automatically fetch these for you on supported package managers.

*   `sddm >= 0.21.0`
*   `qt6-svg`
*   `qt6-virtualkeyboard`
*   `qt6-multimedia` (and `qt6-multimedia-ffmpeg` for video backgrounds)
*   `jq` & `curl` (for parsing student configurations and downloading media assets)

---

## 🛠️ Installation

### Option 1: Automatic Schale Terminal Installer (Recommended)

Simply clone this repository locally, navigate into the directory, and boot the installer:

```bash
git clone https://github.com/RhythmGC/BlueArchive-SDDM-theme.git
cd BlueArchive-SDDM-theme
chmod +x setup.sh
./setup.sh
```

#### Installer Menu Options:
1.  **🚀 Complete Installation (recommended):** Installs all dependencies, prompts you to select your preferred student theme, automatically downloads her background animations, configures the environment, and enables SDDM.
2.  **📦 Install Dependencies:** Automatically installs Qt6 packages, `jq`, and `curl` using your system package manager.
3.  **📥 Download Media:** Select a specific student to download her video/image assets and configure her `.conf`.
4.  **📂 Install Theme:** Copies the theme assets to system directories and sets the current SDDM theme.
5.  **🎨 Select Theme Variant:** Choose which student profile config to apply to the login screen.
6.  **✨ Preview the set theme:** Tests the selected login screen without logging out.

---

### Option 2: Manual Deployment

1.  **Install dependencies** on your Linux distribution:
    ```bash
    # Arch Linux
    sudo pacman -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg jq curl
    
    # Fedora
    sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia jq curl
    ```
2.  **Clone the repository** to the SDDM themes folder:
    ```bash
    sudo git clone https://github.com/RhythmGC/BlueArchive-SDDM-theme.git /usr/share/sddm/themes/BlueArchive-SDDM-theme
    ```
3.  **Copy the Fonts:**
    ```bash
    sudo cp -r /usr/share/sddm/themes/BlueArchive-SDDM-theme/Fonts/* /usr/share/fonts/
    ```
4.  **Set as Current Theme:**
    Edit `/etc/sddm.conf` to set the theme:
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

## ⚙️ Enrolling Students in the Database (`source.json`)

You can easily enroll new students or customize existing background animations by configuring the local `source.json` database.

### 1. Structure of `source.json`
Add a new JSON entry using the student's name as the key, alongside direct URLs to their animated background and fallback image:

```json
{
    "yuuka_hayase": {
        "video": "https://res.cloudinary.com/.../Yuuka_d8qnc0.mp4",
        "image": "https://res.cloudinary.com/.../GTA5An8bUAAsHLp_zg6ptz.jpg"
    },
    "another_student": {
        "video": "https://domain.com/live2d-animation.mp4",
        "image": "https://domain.com/static-artwork.jpg"
    }
}
```

### 2. Download & Apply Assets
*   Run the installer: `./setup.sh`
*   Select **🎨 Select Theme Variant** or **📥 Download Media**.
*   Select the newly enrolled student from the interactive UI.
*   The script will automatically:
    1.  Create `Backgrounds/images/` and `Backgrounds/videos/` folders if they do not exist.
    2.  Download media files to `Backgrounds/images/another_student.jpg` and `Backgrounds/videos/another_student.mp4`.
    3.  Generate or update `Themes/another_student.conf` with the correct relative paths (by copying `yuuka_hayase.conf` as a template).
    4.  Copy files to system theme directories.

---

## 🎨 Schale Terminal Preview

You can preview your selected student theme live without signing out by running:
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/BlueArchive-SDDM-theme/
```
*(Press `Ctrl + C` in terminal to exit the preview greeter)*

---

## 🌟 Kivotos Supporters (Stargazers)

<!-- stargazers_start -->
<p align="left">
  <a href="https://github.com/RhythmGC"><img src="https://avatars.githubusercontent.com/u/125289048?v=4" width="40" height="40" style="border-radius: 50%; margin: 3px;" alt="RhythmGC"/></a>
  <a href="https://github.com/longvoquy"><img src="https://avatars.githubusercontent.com/u/127716758?v=4" width="40" height="40" style="border-radius: 50%; margin: 3px;" alt="longvoquy"/></a>
  <a href="https://github.com/niyakipham"><img src="https://avatars.githubusercontent.com/u/175391259?v=4" width="40" height="40" style="border-radius: 50%; margin: 3px;" alt="niyakipham"/></a>
  <a href="https://github.com/shuzi48"><img src="https://avatars.githubusercontent.com/u/137606442?v=4" width="40" height="40" style="border-radius: 50%; margin: 3px;" alt="shuzi48"/></a>
</p>
<!-- stargazers_end -->

## 🍴 Club Members (Forkers)

<!-- forks_start -->
<p align="left">No stargazers or forkers yet. Be the first!</p>
<!-- forks_end -->

## 📝 License & Copyright

*   Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.
*   Copyright (C) 2026 **[RhythmGC](https://github.com/RhythmGC)**.
*   Originally based on [MarianArlt's sugar-dark](https://github.com/MarianArlt/sddm-sugar-dark) layout concepts.
