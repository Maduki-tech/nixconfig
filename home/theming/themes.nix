# Theme catalog: one entry per selectable theme. This is the single source
# of truth render.nix and theme.nix read from — add a theme here and it
# shows up everywhere (ghostty, hyprland, nvim, gtk, obsidian) automatically.
{ pkgs }:

let
  catppuccinGtk = variant: pkgs.catppuccin-gtk.override {
    inherit variant;
    accents = [ "blue" ];
  };
in
{
  catppuccin-mocha = {
    dark = true;
    colors = {
      accent1 = "89b4fa";
      accent2 = "cba6f7";
      inactive = "6c7086";
      shadow = "1a1a1a";
    };
    ghostty.theme = "Catppuccin Mocha";
    gtk = {
      package = catppuccinGtk "mocha";
      theme = "catppuccin-mocha-blue-standard";
      scheme = "prefer-dark";
    };
    nvim.colorscheme = "catppuccin-mocha";
    obsidian = { cssTheme = "Catppuccin"; base = "obsidian"; };
  };

  catppuccin-latte = {
    dark = false;
    colors = {
      accent1 = "1e66f5";
      accent2 = "8839ef";
      inactive = "9ca0b0";
      shadow = "8c8fa1";
    };
    ghostty.theme = "Catppuccin Latte";
    gtk = {
      package = catppuccinGtk "latte";
      theme = "catppuccin-latte-blue-standard";
      scheme = "prefer-light";
    };
    nvim.colorscheme = "catppuccin-latte";
    obsidian = { cssTheme = "Catppuccin"; base = "moonstone"; };
  };

  tokyonight = {
    dark = true;
    colors = {
      accent1 = "7aa2f7";
      accent2 = "bb9af7";
      inactive = "565f89";
      shadow = "16161e";
    };
    ghostty.theme = "TokyoNight Night";
    gtk = {
      package = pkgs.tokyonight-gtk-theme;
      theme = "Tokyonight-Dark";
      scheme = "prefer-dark";
    };
    nvim.colorscheme = "tokyonight-night";
    obsidian = { cssTheme = "Tokyo Night"; base = "obsidian"; };
  };

  gruvbox = {
    dark = true;
    colors = {
      accent1 = "83a598";
      accent2 = "d3869b";
      inactive = "928374";
      shadow = "1d2021";
    };
    ghostty.theme = "Gruvbox Dark";
    gtk = {
      package = pkgs.gruvbox-gtk-theme;
      theme = "Gruvbox-Dark";
      scheme = "prefer-dark";
    };
    nvim.colorscheme = "gruvbox";
    obsidian = { cssTheme = "Obsidian gruvbox"; base = "obsidian"; };
  };

  nord = {
    dark = true;
    colors = {
      accent1 = "88c0d0";
      accent2 = "81a1c1";
      inactive = "4c566a";
      shadow = "242933";
    };
    ghostty.theme = "Nord";
    gtk = {
      package = pkgs.nordic;
      theme = "Nordic";
      scheme = "prefer-dark";
    };
    nvim.colorscheme = "nord";
    obsidian = { cssTheme = "Obsidian Nord"; base = "obsidian"; };
  };
}
