{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  # All actual config lives in ./hyprland.lua, force-linked below (Hyprland reads
  # .lua over the HM-generated .conf). This just satisfies HM's "did you forget
  # to configure anything" warning — the generated .conf is never read.
  wayland.windowManager.hyprland.extraConfig = "# managed manually via hyprland.lua";

  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };
}
