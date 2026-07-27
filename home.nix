{ config, pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/zsh.nix
    ./home/direnv.nix
    ./home/starship.nix
    ./home/ghostty.nix
    ./home/hyprland.nix
    ./home/quickshell.nix
    ./home/nvim.nix
    ./home/tmux.nix
    ./home/scripts.nix
    ./home/apps.nix
    ./home/theme.nix
    ./home/theming
  ];

  home.username = "maduki";
  home.homeDirectory = "/home/maduki";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
