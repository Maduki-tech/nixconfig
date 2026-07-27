# Wires the theme catalog (themes.nix) into: rendered per-theme asset files
# under ~/.config/theme/themes/<name>/ (render.nix), the theme-set switcher
# script, and the Obsidian community themes theme-set switches between.
#
# Catppuccin's Obsidian theme is already installed by hand in the vault;
# Tokyonight/Gruvbox/Nord are fetched here from their community-theme repos
# (verified against Obsidian's official community-css-themes.json registry)
# and copied into the vault on activation.
{ config, pkgs, lib, ... }:

let
  themes = import ./themes.nix { inherit pkgs; };
  themeFiles = import ./render.nix { inherit lib themes; };
  themeSet = import ./theme-set.nix { inherit pkgs; };

  vaultThemesDir = "$HOME/vault/.obsidian/themes";

  obsidianThemeSrcs = {
    "Tokyo Night" = pkgs.fetchFromGitHub {
      owner = "tcmmichaelb139";
      repo = "obsidian-tokyonight";
      rev = "8266c8650227aabcb4f79b7ad460546b068748d4";
      sha256 = "1yz78kiba9h91v4mbax77fqcsfqlhj63ysbwv8hxdkkvnf3xnzal";
    };
    "Obsidian gruvbox" = pkgs.fetchFromGitHub {
      owner = "insanum";
      repo = "obsidian_gruvbox";
      rev = "bec6c083415980155aefc1a0d26c7cfe68fd85eb";
      sha256 = "1im9f9k7qvg4xzw07h2a4xk4nnfxmrkgss6ng5lsnd3iq3zgfj0a";
    };
    "Obsidian Nord" = pkgs.fetchFromGitHub {
      owner = "insanum";
      repo = "obsidian_nord";
      rev = "f40209f976fab19ae7590018591fd5311e6af7f4";
      sha256 = "00msl6l59bk0zpmvyabg2sg3b8cv6rmfyjlgbhc5xcb7kh9g3n1d";
    };
  };
in
{
  home.packages = [ themeSet pkgs.jq ];

  xdg.configFile = themeFiles;

  home.activation.installObsidianThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (lib.mapAttrsToList (name: src: ''
      run mkdir -p "${vaultThemesDir}/${name}"
      run cp -f "${src}/manifest.json" "${vaultThemesDir}/${name}/manifest.json"
      run cp -f "${src}/theme.css" "${vaultThemesDir}/${name}/theme.css"
    '') obsidianThemeSrcs)
  );
}
