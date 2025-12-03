{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";
      spacing = 8;

      modules-left =
        [ "custom/logo" "cpu" "memory" "temperature" "custom/spotify" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right =
        [ "network" "bluetooth" "clock" "pulseaudio" "custom/power" ];

      # --- Custom Logo ---
      "custom/logo" = {
        format = "";
        on-click = "ghostty -e nix-shell -p nix-info --run 'nix-info -m'";
        tooltip = true;
        tooltip-format = "NixOS Info";
      };

      # --- CPU ---
      "cpu" = {
        format = " {usage}%";
        interval = 2;
        tooltip = true;
        tooltip-format = "CPU: {usage}%";
      };

      # --- Memory ---
      "memory" = {
        format = " {percentage}%";
        interval = 2;
        tooltip = true;
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
      };

      # --- Temperature ---
      "temperature" = {
        thermal-zone = 2;
        critical-threshold = 80;
        format = "{icon} {temperatureC}°C";
        format-icons = {
          default = "🌡️";
          critical = "🔥";
        };
        interval = 2;
        tooltip = true;
      };

      # --- Spotify ---
      "custom/spotify" = {
        format = " {}";
        exec = "playerctl metadata --format '{{ title }} - {{ artist }}'";
        interval = 5;
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        tooltip = false;
      };

      # --- Workspaces ---
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "";
          active = "";
          urgent = "";
        };
        persistent-workspaces = { "*" = 5; };
        on-click = "activate";
      };

      # --- Network ---
      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀 Connected";
        format-disconnected = "󰤮 Offline";
        tooltip = true;
        tooltip-format = ''
          {ifname}: {ipaddr}
          ↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}'';
        on-click = "nm-connection-editor";
        interval = 2;
      };

      # --- Bluetooth ---
      "bluetooth" = {
        format = "󰂯";
        format-connected = "󰂯 {num_connections}";
        format-disabled = "󰂲";
        format-off = "󰂲";
        on-click = "blueman-manager";
        tooltip = true;
        tooltip-format = "{controller_alias}	{controller_address}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
      };

      # --- Clock ---
      "clock" = {
        format = " {:%d.%m %a %H:%M}";
        tooltip = true;
        tooltip-format = ''
          <big>{:%B %Y}</big>
          <tt><small>{calendar}</small></tt>'';
      };

      # --- Pulseaudio (PipeWire-backed) ---
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Muted";
        format-icons = {
          headphone = "󰋋";
          hands-free = "󰍽";
          headset = "󰋋";
          phone = "";
          portable = "";
          car = "";
          default = [ "󰕾" "󰖀" "󰖁" ];
        };
        on-click = "pavucontrol";
        on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip = true;
        tooltip-format = "Volume: {volume}%";
      };

      # --- Power Button ---
      "custom/power" = {
        format = "⏻ ";
        on-click = "wlogout";
        tooltip = true;
        tooltip-format = "Power Menu";
      };
    }];

    style = builtins.readFile ./style.css;
  };
}
