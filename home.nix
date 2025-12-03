{ inputs, pkgs, ... }:

{
  home = {
    username = "maduki";
    homeDirectory = "/home/maduki";
    shell.enableFishIntegration = true;

    packages = with pkgs; [
      fzf
      cargo
      spotify
      wget
      curl
      unzip
      ripgrep
      killall
      claude-code

      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.fira-code

      # Icon themes for waybar and other applications
      papirus-icon-theme
      adwaita-icon-theme
      font-awesome

      noto-fonts
      noto-fonts-color-emoji

      libnotify
      wl-clipboard # clipboard manager
      wlogout # power menu for waybar
      hyprlock # lock screen for hyprland
      hypridle # idle management daemon

      bun
      nodejs_24
      python314
      go
      gcc
      statix

      discord
      spotify
      obsidian
    ];

    stateVersion = "25.05";
  };

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Maduki-tech";
        email = "d.schlueter1011@gmail.com";
      };
    };

    gh = {
      enable = true;
      settings = { git_protocol = "ssh"; };
    };

    zsh = { enable = true; };

    lazygit = { enable = true; };
  };

  imports =
    [ ./programs ./portals ./theme inputs.zen-browser.homeModules.beta ];
  programs.zen-browser.enable = true;

  fonts.fontconfig.enable = true;
}

