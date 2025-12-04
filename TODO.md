# Desktop Environment TODO

This file tracks missing components for a complete Hyprland desktop environment.

## 🔔 Notifications

- [ ] **mako** - Lightweight notification daemon for Wayland
- [ ] **dunst** - Highly configurable notification daemon (alternative)
- [ ] **swaync** (SwayNotificationCenter) - Feature-rich notification center
    with panel

## 📸 Screenshot Tools

- [ ] **grim** - Screenshot tool for Wayland compositors
- [ ] **slurp** - Select region tool (works with grim for area screenshots)
- [ ] **swappy** - Annotation/editing tool for screenshots
- [ ] **flameshot** - Full-featured screenshot tool (has Wayland support)

## 🎥 Screen Recording

- [ ] **wf-recorder** - Screen recording for Wayland
- [ ] **obs-studio** - Professional recording/streaming software
- [ ] **gpu-screen-recorder** - Hardware-accelerated screen recording

## 📁 File Manager

- [ ] **thunar** - GTK file manager with good plugin support
- [ ] **nemo** - Cinnamon file manager (feature-rich)
- [ ] **dolphin** - KDE file manager (most features)
- [ ] **nautilus** - GNOME file manager
- [ ] **yazi** - Terminal file manager (modern alternative to ranger)

## 🖼️ Image Viewer

- [ ] **imv** - Wayland-native image viewer
- [ ] **sxiv** - Simple X Image Viewer (works with Xwayland)
- [ ] **feh** - Fast image viewer

## 📄 Document Viewer

- [ ] **zathura** - Minimalist PDF viewer with vim keybindings
- [ ] **evince** - GNOME document viewer (supports PDF, DjVu, etc.)
- [ ] **okular** - KDE document viewer (feature-rich)

## 🎨 Color Picker

- [ ] **hyprpicker** - Wayland color picker for Hyprland
- [ ] **gpick** - Advanced color picker with palette management

## 🔐 Authentication & Polkit

- [ ] **polkit-gnome** - Polkit authentication agent (for sudo GUI prompts)
- [ ] **polkit-kde-agent** - KDE polkit agent (alternative)
- [ ] **lxqt-policykit** - LXQt polkit agent (lightweight)

## 📋 Clipboard Manager

Currently: wl-clipboard (basic)

- [ ] **cliphist** - Clipboard history manager for Wayland
- [ ] **copyq** - Advanced clipboard manager with history

## 🌐 Network Management GUI

Currently: blueman for Bluetooth

- [ ] **nm-applet** (networkmanagerapplet) - System tray network manager
- [ ] **nm-connection-editor** - Network connection editor GUI

## 🔊 Audio Control

Currently: PulseAudio controls in waybar

- [ ] **pavucontrol** - PulseAudio/PipeWire volume control GUI
- [ ] **pwvucontrol** - Native PipeWire volume control (modern alternative)
- [ ] **easyeffects** - Audio effects and equalizer

## 🖱️ Display Configuration

- [ ] **wdisplays** - GUI display configuration for Wayland
- [ ] **nwg-displays** - Output management for Wayland compositors

## 🎭 Wallpaper Management

Currently: swww (installed but not configured)

- [ ] Configure **swww** with startup scripts
- [ ] **waypaper** - GUI wallpaper manager for Wayland
- [ ] **wpaperd** - Wallpaper daemon with multi-monitor support

## 📦 Application Launcher

Currently: rofi (configured)

- [x] rofi - Already configured
- [ ] **wofi** - Wayland-native launcher (alternative)
- [ ] **fuzzel** - Application launcher for Wayland (minimal)
- [ ] **tofi** - Tiny Wayland application launcher

## 🔍 System Monitor

- [ ] **btop** - Modern system monitor (terminal)
- [ ] **htop** - Interactive process viewer (terminal)
- [ ] **mission-center** - GUI system monitor (like Windows Task Manager)

## 🗂️ Archive Manager

- [ ] **file-roller** - GNOME archive manager
- [ ] **ark** - KDE archive manager
- [ ] **xarchiver** - Lightweight archive manager

## ✏️ Text Editor (GUI)

Currently: neovim (terminal)

- [ ] **gedit** - Simple GTK text editor
- [ ] **kate** - KDE text editor
- [ ] **mousepad** - Lightweight GTK editor

## 🌙 Blue Light Filter

- [ ] **wlsunset** - Day/night gamma adjustment for Wayland
- [ ] **gammastep** - Blue light filter (Wayland redshift fork)
- [ ] **hyprsunset** - Hyprland-specific blue light filter

## 🖨️ Printer Support

- [ ] **cups** - Printing system
- [ ] **system-config-printer** - CUPS configuration GUI

## 🎮 Gaming Utilities (Optional)

- [ ] **gamemode** - Optimize system performance for games
- [ ] **mangohud** - Gaming overlay for FPS/performance monitoring
- [ ] **steam** - Gaming platform

## 🔄 System Services to Enable

- [ ] **pipewire** - Modern audio server (should replace PulseAudio)
- [ ] **wireplumber** - PipeWire session manager
- [ ] **udisks2** - Disk management service
- [ ] **gvfs** - Virtual filesystem (for trash, mounting, etc.)
- [ ] **tumbler** - Thumbnail generation service
- [ ] **xdg-desktop-portal-hyprland** - Desktop portal implementation
- [ ] **xdg-desktop-portal-gtk** - GTK file picker portal

## 🎨 Theming Components

Currently: GTK theme (Adwaita-dark), cursor theme configured

- [ ] **qt5ct** / **qt6ct** - Qt theme configuration
- [ ] **kvantum** - Qt theme engine
- [ ] **lxappearance** - GTK theme switcher GUI
- [ ] **nwg-look** - GTK theme switcher for Wayland

## 🔧 System Utilities

- [ ] **brightnessctl** - Brightness control for backlight
- [ ] **playerctl** - Media player controller (for waybar Spotify module)
- [ ] **wev** - Wayland event viewer (debugging key/mouse events)
- [ ] **wlr-randr** - Display configuration tool for wlroots compositors

## 📦 Package Management GUI (Optional)

- [ ] **nix-software-center** - GUI for browsing NixOS packages
- [ ] **nixos-conf-editor** - GUI configuration editor for NixOS

## Priority Order (Recommended Implementation)

### Critical (Implement First)

1. Notification daemon (mako or dunst)
2. Screenshot tools (grim + slurp)
3. File manager (thunar recommended)
4. Polkit agent (polkit-gnome)
5. Pavucontrol (audio GUI)
6. Playerctl (for waybar Spotify module)

### High Priority

- Clipboard history (cliphist)
- Image viewer (imv)
- PDF viewer (zathura)
- Color picker (hyprpicker)
- System monitor (btop)
- Brightness control (brightnessctl)

### Medium Priority

- Screen recording (wf-recorder)
- Display configuration (wdisplays)
- Archive manager (file-roller)
- Blue light filter (wlsunset or hyprsunset)
- Network manager applet (nm-applet)

### Nice to Have

- Theming tools (qt5ct, lxappearance)
- Advanced clipboard (copyq)
- System monitoring (mission-center)
- Printer support (cups)
