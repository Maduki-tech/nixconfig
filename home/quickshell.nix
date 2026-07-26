{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    brightnessctl
    gtk3
  ];

  xdg.configFile."quickshell" = {
    source = ./quickshell;
    recursive = true;
  };
}
