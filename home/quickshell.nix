{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    brightnessctl
    gtk3
    grim
    wl-clipboard
  ];

  xdg.configFile."quickshell" = {
    source = ./quickshell;
    recursive = true;
  };
}
