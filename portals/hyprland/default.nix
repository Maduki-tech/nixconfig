{ host, ... }: {
  imports = [
    ./hyprland.nix
    ./bindings.nix
    ./hyprcursor.nix
    ./hyprpaper.nix
    ./startup.nix
    ./animations.nix
  ];
}
