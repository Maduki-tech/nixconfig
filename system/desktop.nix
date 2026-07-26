{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # dconf backs the GTK dark color-scheme setting written by home/theme.nix.
  programs.dconf.enable = true;

  # xdg-desktop-portal-hyprland (enabled by the hyprland module above) only
  # implements Screenshot/ScreenCast/etc. Add the gtk portal so the Settings
  # interface (org.freedesktop.appearance color-scheme) is available for
  # portal-aware apps, e.g. Electron's dark-mode detection on Linux.
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "hyprland" "gtk" ];
  };
}
