{ config, pkgs, ... }:

{
  # Tools tmux.conf and its key-bound scripts (cht.sh, tmux-sessiongod.sh) shell out to.
  home.packages = with pkgs; [
    tmux
    fzf
    curl
  ];

  # Keep the config live-editable in its own dotfiles repo rather than
  # copying it into the nix store.
  xdg.configFile."tmux".source =
    config.lib.file.mkOutOfStoreSymlink "/home/maduki/dotfile/tmux/tmux";
}
