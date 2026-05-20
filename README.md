# BlueArchive-SDDM-theme

![Stars](https://img.shields.io/github/stars/RhythmGC/BlueArchive-SDDM-theme?color=dd864a&labelColor=1b1b25&style=for-the-badge)
![Forks](https://img.shields.io/github/forks/RhythmGC/BlueArchive-SDDM-theme?color=bf616a&labelColor=1b1b25&style=for-the-badge)

[BlueArchive-SDDM-theme](https://github.com/RhythmGC/BlueArchive-SDDM-theme) is a series of themes for the [SDDM](https://github.com/sddm/sddm/) display manager made by **[RhythmGC](https://github.com/RhythmGC)**.

It's written using the latest version of Qt, which is **Qt6**. Its key features include **virtual keyboard support** and an **installation script**. This theme also support **animated wallpapers**. You can easily change its appearance by choosing another of the ten pre-made themes or creating your own. Each of these themes was created by modifying just one file - **[config](./Themes/astronaut.conf)**.

All themes were created for 1080p. However, they should work well in other resolutions.

## Preview of all themes

![all_themes.gif](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/all_themes.gif?raw=true)

## Preview of animated themes

https://github.com/user-attachments/assets/2cfc947e-4621-4e98-b5f3-07d5e224b80c

<!-- <h2><a href="https://youtu.be/4tQ56xh7wBc" target="_blank">Watch more on Youtube!</a></h2> -->
<details>
<summary><h2>Detailed previews</h2></summary>

**Astronaut**|**Black hole**
|:--:|:--:|
![astronaut](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/astronaut.png?raw=true)|![black_hole](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/black_hole.png?raw=true)
**Japanese aesthetic**|**Pixel sakura static**
![japanese_aesthetic](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/japanese_aesthetic.png?raw=true)|![pixel_sakura_static](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/pixel_sakura_static.png?raw=true)
**Purple leaves**|**Cyberpunk**
![purple_leaves](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/purple_leaves.png?raw=true)|![cyberpunk](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/cyberpunk.png?raw=true)
**Post-apocalyptic hacker**|**xxx**
![post-apocalyptic_hacker](https://github.com/RhythmGC/screenshots/blob/master/BlueArchive-SDDM-theme/master/post-apocalyptic_hacker.png?raw=true)|

**Hyprland Kath**

https://github.com/user-attachments/assets/1d926e76-44f7-4d99-ac6d-d1abcd7ed688

**Pixel sakura**

https://github.com/user-attachments/assets/ea004765-7e84-4a0d-90cd-aaac97679f62

**Jake the dog**

https://github.com/user-attachments/assets/181d48c2-f152-45f5-b568-21145be180f6

</details>

## Installation

### Automatic Installation

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RhythmGC/BlueArchive-SDDM-theme/master/setup.sh)"
```
> Works on distributions using pacman, xbps-install, dnf, zypper.   
> Remember to always read the scripts you run from the internet.

### Customizing Themes with `source.json`

You can easily add new themes with your own video and image backgrounds by configuring the `source.json` file in the root directory.

1. **Format of `source.json`:**
   Add a new entry with your desired theme name. Provide direct URLs to your video and image.

   ```json
   {
       "my_custom_theme": {
           "video": "https://example.com/path/to/video.mp4",
           "image": "https://example.com/path/to/image.jpg"
       },
       "yuuka_hayase": {
           "video": "https://res.cloudinary.com/.../Yuuka.mp4",
           "image": "https://res.cloudinary.com/.../GTA5.jpg"
       }
   }
   ```

2. **Download & Apply:**
   - Run the script locally: `./setup.sh`
   - Select **🚀 Complete Installation** or **📥 Download Media**.
   - The script will prompt you to select the theme. 
   - Upon selecting your custom theme (e.g., `my_custom_theme`), the script will automatically download the media files to the `Backgrounds/` folder, setup a custom `.conf` file in the `Themes/` folder, and apply it.

### Manual Installation

1. Install **dependencies**

[`sddm >= 0.21.0`](https://github.com/sddm/sddm), [`qt6 >= 6.8`](https://doc.qt.io/qt-6/index.html), [`qt6-svg >= 6.8`](https://doc.qt.io/qt-6/qtsvg-index.html), [`qt6-virtualkeyboard >= 6.8`](https://doc.qt.io/qt-6/qtvirtualkeyboard-index.html), [`qt6-multimedia >= 6.8`](https://doc.qt.io/qt-6/qtmultimedia-index.html)

You may also want to install additional video codecs like h.264.

```sh
sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg     # Arch
sddm qt6-svg qt6-virtualkeyboard qt6-multimedia            # Void
sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia      # Fedora
sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports        # OpenSUSE
sddm libqt6svg6 qt6-virtualkeyboard-plugin libqt6multimedia6 qml6-module-qtquick-controls qml6-module-qtquick-effects libxcb-cursor0 # Debian Unstable
```

2. Clone this repository
```sh
sudo git clone -b master --depth 1 https://github.com/RhythmGC/BlueArchive-SDDM-theme.git /usr/share/sddm/themes/BlueArchive-SDDM-theme
```
3. Copy fonts to `/usr/share/fonts/`
```sh
sudo cp -r /usr/share/sddm/themes/BlueArchive-SDDM-theme/Fonts/* /usr/share/fonts/
```
4. Edit `/etc/sddm.conf`
```sh
echo "[Theme]
Current=BlueArchive-SDDM-theme" | sudo tee /etc/sddm.conf
```
5. Edit `/etc/sddm.conf.d/virtualkbd.conf`
```sh
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
```

## Selecting a theme

You can select theme by editing [metadata](./metadata.desktop) (`/usr/share/sddm/themes/BlueArchive-SDDM-theme/metadata.desktop`).

Just edit this line:
```
ConfigFile=Themes/astronaut.conf
```
All available configs are in [Themes](./Themes/) directory.

## Previewing a theme

You can preview the set theme without logging out by runnning:
```sh
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/BlueArchive-SDDM-theme/
```
> Note that depending on the system configuration, the preview may differ slightly from the actual login screen.

## Sources

Initially the theme was independed fork of [MarianArlt's theme](https://github.com/MarianArlt/sddm-sugar-dark) but now the project has come a long way and started to significantly deviate from the original.
Many of the wallpapers and fonts used in this project are very popular and copied from one user to another, so I don't know who the original creator is. 
I also redesigned many of them, but here are links to some of the orginal artists who created these wonderful wallpapers:

- Astronaut: [wallpaper](https://wallhaven.cc/w/e76pew), [font](https://fonts.google.com/specimen/Open+Sans/about)
- Black hole: [wallpaper](https://images2.alphacoders.com/114/1141632.jpg), [font](https://www.1001fonts.com/espacion-font.html)
- Japanese aesthetic: [wallpaper](https://imgur.com/a/pua0dYx) by [gharly](https://www.artstation.com/gharly), [font](https://www.1001fonts.com/electroharmonix-font.html)
- Purple leaves: [wallpaper](https://wallha.com/wallpaper/artwork-abstract-leaves-purple-texture-pattern-1414432), [font](https://fonts.google.com/specimen/Open+Sans/about)
- Cyberpunk: [wallpaper](https://images5.alphacoders.com/133/1330479.png) by [patrika](https://alphacoders.com/users/profile/227699/patrika), [font](https://www.1001fonts.com/kognigear-font.html)
- Post-apocalyptic hacker:  [wallpaper](https://images.alphacoders.com/137/thumb-1920-1375178.png) by [patrika](https://alphacoders.com/users/profile/227699/patrika), [font](https://www.1001fonts.com/fragile-bombers-font.html)
- Hyprland Kath: [wallpaper](https://motionbgs.com/andvari-last-origin), [font](https://www.1001fonts.com/pixelon-font.html)
- Pixel sakura: [wallpaper](https://imgur.com/gallery/sakura-tree-with-petals-flying-off-t5tg4N8), [font](https://www.1001fonts.com/arcadeclassic-font.html)
- Jake the dog: [wallpaper](https://motionbgs.com/jake-the-dog), [font](https://fontmeme.com/fonts/thunderman-font/)
  
## Supporting project

You can support me simply by dropping a **star** on **[github](https://github.com/RhythmGC/BlueArchive-SDDM-theme)**.

Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.    
Copyright (C) 2026 RhythmGC.
