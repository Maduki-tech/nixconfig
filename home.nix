{ inputs, pkgs, ... }:

let
  # Override go-migrate to exclude Snowflake driver which causes CA cert parsing panic
  # Adjust the tags array to match your database (e.g., "postgres", "mysql", "sqlite3", "pgx")
  go-migrate-fixed = pkgs.go-migrate.overrideAttrs (oldAttrs: {
    tags = [ "postgres" ]; # Change this to your database type
  });
in {
  home = {
    username = "maduki";
    homeDirectory = "/home/maduki";
    shell.enableFishIntegration = true;

    packages = with pkgs; [
      fzf
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

      #JS
      bun
      nodejs_24

      python314
      # GO
      go
      gopls
      sqlc
      go-migrate-fixed
      # C
      gcc
      gnumake
      statix
      # Rust
      cargo
      rustc
      rust-analyzer
      clippy
      rustfmt

      # Zig
      zig

      # Programs
      discord
      spotify
      obsidian
      ticktick
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
    lazydocker = { enable = true; };

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

