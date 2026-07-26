{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
  };

  # Keep the config live-editable in its own dotfiles repo rather than
  # copying it into the nix store (ghostty-toggle-opacity edits it in place).
  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/maduki/dotfile/ghostty/ghostty";
    force = true;
  };
}
