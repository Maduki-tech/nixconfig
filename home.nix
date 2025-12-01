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
      claude-code

      nerd-fonts.jetbrains-mono
      nerd-fonts.hack

      libnotify
      wl-clipboard # clipboard manager

      bun
      nodejs_24
      python314
      go
      gcc
      statix

      rofi
      notion-app
      notion-app-enhanced
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
  };

  imports =
    [ ./programs ./portals ./theme inputs.zen-browser.homeModules.beta ];
  programs.zen-browser.enable = true;

  fonts.fontconfig.enable = true;
}

