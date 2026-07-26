{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.obsidian
    pkgs.obs-studio
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
