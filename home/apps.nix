{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.obsidian
    pkgs.obs-studio
    pkgs.libnotify
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
