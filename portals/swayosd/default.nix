{ pkgs, ... }:

{
  services.swayosd = {
    enable = true;
    package = pkgs.swayosd;
    stylePath = ./style.css;
    topMargin = 0.9; # Near top, macOS-like positioning
  };
}
