{ pkgs, ... }:

{
  services.mako = {
    enable = true;

    settings = {

      # Appearance - Catppuccin Mocha
      background-color = "#181825DD"; # Surface0
      text-color = "#cdd6f4"; # Text
      border-color = "#89b4fa"; # Blue
      progress-color = "over #313244"; # Surface0

      border-size = 3;
      border-radius = 12;

      # Font
      font = "JetBrainsMono Nerd Font 11";

      # Layout
      width = 400;
      height = 150;
      margin = "20";
      padding = "15";

      # Position (top-right)
      anchor = "top-right";

      # Behavior
      default-timeout = 3000; # 5 seconds
      ignore-timeout = false;

      # Icons
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      max-icon-size = 48;

      # Grouping
      group-by = "app-name";

      # Interaction
      layer = "overlay";

    };
    # Additional settings - Catppuccin Mocha urgency colors
    extraConfig = ''
      [urgency=low]
      background-color=#181825DD
      border-color=#585b70
      text-color=#a6adc8
      default-timeout=3000

      [urgency=normal]
      background-color=#181825DD
      border-color=#89b4fa
      text-color=#cdd6f4
      default-timeout=5000

      [urgency=high]
      background-color=#181825DD
      border-color=#f38ba8
      text-color=#f5c2e7
      default-timeout=0
      ignore-timeout=1
    '';
  };
}
