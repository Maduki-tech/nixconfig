{ config, pkgs, ... }:

{
  # Keep the scripts live-editable in their own dotfiles repo rather than
  # copying them into the nix store.
  xdg.configFile."script".source =
    config.lib.file.mkOutOfStoreSymlink "/home/maduki/dotfile/script/script";

  home.sessionPath = [ "${config.xdg.configHome}/script" ];
}
