{ config, pkgs, ... }:

let
  # hyprsplit is a pure-Lua Hyprland module (no .so/hyprpm plugin involved) that
  # gives each monitor its own independent set of workspaces. Vendored directly
  # (same pattern as the theming module's fetchFromGitHub sources) instead of
  # pulling in the upstream flake, which drags in all of github:hyprwm/Hyprland
  # just to build a C++ variant we don't need; nixpkgs' hyprlandPlugins.hyprsplit
  # is also currently broken against Hyprland 0.55+.
  hyprsplitSrc = pkgs.fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "6b00b677d8905fb38779c91e12d6294e0e586a44";
    hash = "sha256-PaoUtmk+qIP/ESdxkxnY7mUMpMHjix88qu22R5GLQqE=";
  };
in
{
  wayland.windowManager.hyprland.enable = true;
  # All actual config lives in ./hyprland.lua, force-linked below (Hyprland reads
  # .lua over the HM-generated .conf). This just satisfies HM's "did you forget
  # to configure anything" warning — the generated .conf is never read.
  wayland.windowManager.hyprland.extraConfig = "# managed manually via hyprland.lua";

  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };

  # Lets hyprland.lua's `require("hyprsplit")` resolve to hyprsplit/init.lua,
  # the same way it already resolves `require("theme")`.
  xdg.configFile."hypr/hyprsplit/init.lua" = {
    source = "${hyprsplitSrc}/init.lua";
    force = true;
  };
}
