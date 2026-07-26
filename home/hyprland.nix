{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
        kb_layout = "de,us";
        kb_options = "grp:alt_shift_toggle";
        natural_scroll = true;

        touchpad = {
          natural_scroll = true;
        };
      };
    };
  };
}
