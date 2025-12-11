{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # AMD-specific kernel parameters for Ryzen AI 9 365 and Radeon 880M
    kernelParams = [
      "amd_pstate=active" # AMD P-State for Zen 5
      "amdgpu.dc=1" # Display Core
      "pcie_aspm=force" # PCIe power management
      "pcie_aspm.policy=powersupersave"
    ];

    kernelPackages = pkgs.linuxPackages_latest; # Latest kernel for best AMD support
  };

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
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
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

    # Laptop-specific utilities
    brightnessctl # Brightness control
    powertop # Power consumption analysis
    acpi # Battery/power information
    lshw # Hardware lister
    pciutils # lspci for GPU info
    usbutils # lsusb for USB devices
    radeontop # AMD GPU monitoring
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
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red --user-menu --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    blueman.enable = true;

    # Power management for balanced performance/battery
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 5;
      criticalPowerAction = "Hibernate";
    };

    fwupd.enable = true; # Firmware updates for Lenovo

    # PipeWire audio server
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Lid switch behavior
    logind.settings.Login = {
      HandleLidSwitch = "suspend";              # Suspend when lid closes on battery
      HandleLidSwitchExternalPower = "ignore";  # Ignore lid close when plugged in
      HandleLidSwitchDocked = "ignore";         # Ignore lid close when docked
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  # Power management configuration
  powerManagement = {
    enable = true;
    cpuFreqGovernor = null; # Let amd_pstate handle it
    powertop.enable = true;
  };

  # BLUETOOTH
  hardware = {
    bluetooth.enable = true;

    # AMD GPU Configuration for Radeon 880M (RDNA 3.5)
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa
        libvdpau-va-gl
        libva-vdpau-driver
        vulkan-loader
        vulkan-validation-layers
        libva
        libva-utils
      ];

      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
      ];
    };

    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  system.stateVersion = "25.11";
}
