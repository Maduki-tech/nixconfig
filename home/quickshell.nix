{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    quickshell
    brightnessctl
    gtk3
    grim
    wl-clipboard
    awww # wallpaper daemon/CLI (formerly "swww", upstream renamed the project)
  ];

  xdg.configFile."quickshell" = {
    source = ./quickshell;
    recursive = true;
  };

  # Folder the wallpaper picker (WallpaperMenu.qml) lists images from.
  home.activation.createWallpaperDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/Pictures/Wallpapers"
  '';
}
