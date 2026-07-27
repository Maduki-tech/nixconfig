# Turns the theme catalog (./themes.nix) into the static per-theme asset
# files theme-set switches between at runtime. Every theme gets its own
# directory under ~/.config/theme/themes/<name>/; theme-set just symlinks
# ~/.config/theme/current at the chosen one and copies/broadcasts from there.
{ lib, themes }:

let
  mkGhosttyConf = theme: ''
    theme = "${theme.ghostty.theme}"
  '';

  mkHyprTheme = theme: ''
    return {
    	active_border = { colors = { "rgba(${theme.colors.accent1}ee)", "rgba(${theme.colors.accent2}ee)" }, angle = 45 },
    	inactive_border = "rgba(${theme.colors.inactive}aa)",
    	shadow = 0xee${theme.colors.shadow},
    }
  '';

  mkNvimTheme = theme: ''
    return {
    	{ "LazyVim/LazyVim", opts = { colorscheme = "${theme.nvim.colorscheme}", background = "${if theme.dark then "dark" else "light"}" } },
    }
  '';

  perTheme = name: theme: {
    "theme/themes/${name}/ghostty.conf".text = mkGhosttyConf theme;
    "theme/themes/${name}/hypr-theme.lua".text = mkHyprTheme theme;
    "theme/themes/${name}/nvim-theme.lua".text = mkNvimTheme theme;
    "theme/themes/${name}/gtk-theme".text = theme.gtk.theme;
    "theme/themes/${name}/gtk-scheme".text = theme.gtk.scheme;
    "theme/themes/${name}/obsidian-css-theme".text = theme.obsidian.cssTheme;
    "theme/themes/${name}/obsidian-base".text = theme.obsidian.base;
  };
in
lib.foldl' (acc: name: acc // perTheme name themes.${name}) { } (builtins.attrNames themes)
