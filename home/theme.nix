{ pkgs, ... }:

{
  # System-wide dark mode: sets GTK3/4 dark theme + color-scheme (also
  # written to dconf, which xdg-desktop-portal-gtk exposes to portal-aware
  # apps like Electron), and points Qt apps at the same GTK theme so
  # everything (OBS, Firefox, Obsidian, etc.) follows one dark theme.
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    colorScheme = "dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

  # macOS-style pointer. XCURSOR_SIZE/HYPRCURSOR_SIZE and the theme name
  # for Hyprland itself are set directly in hyprland.lua (env vars set
  # there are proven to reach the compositor; HM's session vars aren't).
  # This block covers everything else: the package, GTK's cursor, and the
  # ~/.icons + XDG data symlinks other apps look up cursors through.
  home.pointerCursor = {
    enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };
}
