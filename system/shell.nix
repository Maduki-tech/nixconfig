{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.maduki.shell = pkgs.zsh;
}
