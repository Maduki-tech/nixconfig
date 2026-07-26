{ config, pkgs, ... }:

{
  # Lid switch behaviour:
  # - Undocked (no external monitor detected): closing the lid suspends,
  #   like a normal laptop.
  # - Docked (external monitor connected, e.g. via the docking station):
  #   closing the lid does nothing at the logind level — Hyprland turns
  #   the internal panel off instead (see home/hyprland.lua), keeping the
  #   external monitors on and the system running.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
