{ pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "uwu"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  users.users.maduki = {
    isNormalUser = true;
    description = "Maduki";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono Nerd Font" ];
        sansSerif = [ "JetBrains Mono Nerd Font" ];
        serif = [ "JetBrains Mono Nerd Font" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    kitty
    ghostty
    wget
    git
    tree-sitter
    luajitPackages.luarocks_bootstrap
    vimPlugins.nvim-treesitter.withAllGrammars
    gh
    file
    btop
  ];
  programs = {

    # Hyprland Init
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    firefox.enable = true;
    zsh.enable = true;
  };

  services = {

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Display Manager - greetd with tuigreet
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.tuigreet}/bin/tuigreet --time --remember --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red --user-menu --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    blueman.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  # BLUETOOTH
  hardware.bluetooth.enable = true;

  system.stateVersion = "25.11";
}
