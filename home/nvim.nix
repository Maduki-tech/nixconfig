{ config, pkgs, ... }:

let
  # Every launch listens on its own socket so theme-set can broadcast a
  # colorscheme reload (User LazyReload, see
  # ../dotfile/nvim/nvim/lua/plugins/omarchy-theme-hotreload.lua) to every
  # open instance/tmux pane, not just the one that's focused.
  nvimListening = pkgs.writeShellScriptBin "nvim" ''
    exec ${pkgs.neovim}/bin/nvim --listen "/tmp/nvim-$$.sock" "$@"
  '';
in
{
  # Plain package, not programs.neovim: that module manages its own
  # .config/nvim/init.lua, which collides with the directory-level
  # symlink below (LazyVim owns the whole config tree instead).
  home.sessionVariables.EDITOR = "nvim";

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  # Tools this LazyVim config shells out to at runtime:
  # - ripgrep, fd: telescope/LazyVim pickers
  # - lazygit: LazyVim git integration
  # - gcc, gnumake, unzip: nvim-treesitter parser builds + mason installs
  # - nodejs, python3: language servers/tools mason installs (vtsls, prettier, pyright, ...)
  # - stylua, clang-tools: formatters referenced directly in conform.lua
  # - rustup: rustaceanvim runs `rustup run stable rustc --print sysroot`
  # - go: Go toolchain (gopls/other Go tools are installed via mason)
  home.packages = [ nvimListening ] ++ (with pkgs; [
    ripgrep
    fd
    lazygit
    gcc
    gnumake
    unzip
    nodejs_22
    python3
    stylua
    clang-tools
    rustup
    go
  ]);

  # Keep the config live-editable in its own dotfiles repo rather than
  # copying it into the nix store.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/maduki/dotfile/nvim/nvim";
}
