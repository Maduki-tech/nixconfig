{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "custom/spotify" ];
      modules-right =
        [ "network" "bluetooth" "clock" "pulseaudio" "custom/system" ];

      # --- Workspaces ---
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "";
          active = "";
          urgent = "";
        };
        tooltip = true;
      };

      # --- Clock ---
      "clock" = {
        format = " {:%H:%M  %d.%m}";
        tooltip = false;
      };

      # --- Pulseaudio (PipeWire-backed) ---
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = " muted";
        format-icons = {
          default = [ "" "" "" ]; # dynamic based on volume level
        };
        on-click = "pavucontrol";
        on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip = true;
        tooltip-format = "Volume: {volume}%";
      };

      # --- Network ---
      "network" = {
        format-wifi = " {bandwidthDownBits} ↓↑ {bandwidthUpBits}";
        format-ethernet = "󰈀 {bandwidthDownBits} ↓↑ {bandwidthUpBits}";
        format-disconnected = "󰤮 Offline";
        interval = 2;
      };

      # --- Bluetooth ---
      "bluetooth" = {
        format-connected = "󰂯 {num_connections}";
        format-off = "󰂲";
        on-click = "blueman-manager";
        tooltip = true;
      };

      # --- System Menu ---
      "custom/system" = {
        format = "";
        on-click = "wlogout";
        tooltip = true;
      };

      # --- Spotify ---
      "custom/spotify" = {
        format = " {}";
        exec = "playerctl metadata --format '{{ title }} - {{ artist }}'";
        interval = 5;
        on-click = "playerctl play-pause";
        tooltip = false;
      };
    }];

    # --- Style (Catppuccin Macchiato theme) ---
    style = ''
      @define-color base      #24273a;
      @define-color surface0  #363a4f;
      @define-color text      #cad3f5;
      @define-color blue      #8aadf4;
      @define-color mauve     #c6a0f6;
      @define-color green     #a6da95;
      @define-color yellow    #eed49f;
      @define-color pink      #f5bde6;
      @define-color red       #ed8796;

      * {
        font-family: JetBrains Mono Nerd Font, monospace;
        font-size: 15px; /* Larger for better readability */
        border: none;
        border-radius: 6px; /* Light curvature inside modules */
      }

      window#waybar {
        background: rgba(36, 39, 58, 0.6); /* Semi-transparent Catppuccin base */
        color: @text;
        border: none;
        margin: 8px 16px; /* floating feel */
        padding: 4px 12px;
        border-radius: 0; /* straight corners for the overall bar */
      }

      #workspaces button {
        padding: 0 8px;
        color: @text;
        background: transparent;
        border-radius: 4px;
      }

      #workspaces button.active {
        background-color: @surface0;
        color: @mauve;
      }

      #workspaces button:hover {
        background: rgba(198, 160, 246, 0.1);
      }

      #clock {
        color: @blue;
        padding: 0 12px;
        font-weight: bold;
      }

      #network {
        color: @yellow;
        padding: 0 12px;
      }

      #bluetooth {
        color: @green;
        padding: 0 12px;
      }

      #custom-system {
        color: @red;
        padding: 0 12px;
      }

      #pulseaudio {
          color: @blue;
          padding: 0 12px;
      }

      #pulseaudio.muted {
          color: @red;
          opacity: 0.6;
      }

      #custom-spotify {
        color: @pink;
        padding: 0 12px;
        font-style: italic;
      }

    '';
  };
}
