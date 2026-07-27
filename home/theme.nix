{ pkgs, ... }:

let
  themes = import ./theming/themes.nix { inherit pkgs; };
  # Default GTK theme on a fresh rebuild. theme-set overrides this live via
  # gsettings; note that `nixos-rebuild switch` reasserts this default
  # afterward, same as it does for any other declarative setting, so re-run
  # `theme-set <name>` post-rebuild if you'd switched away from it.
  default = themes.catppuccin-mocha;
in
{
  # System-wide dark mode: sets GTK3/4 theme + color-scheme (also written to
  # dconf, which xdg-desktop-portal-gtk exposes to portal-aware apps like
  # Electron), and points Qt apps at the same GTK theme so everything (OBS,
  # Firefox, Obsidian, etc.) follows one theme.
  gtk = {
    enable = true;
    theme = {
      name = default.gtk.theme;
      package = default.gtk.package;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    colorScheme = if default.dark then "dark" else "light";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.sessionVariables.GTK_THEME = default.gtk.theme;

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
