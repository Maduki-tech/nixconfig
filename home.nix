{ config, pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/ghostty.nix
    ./home/hyprland.nix
    ./home/quickshell.nix
  ];

  home.username = "maduki";
  home.homeDirectory = "/home/maduki";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
