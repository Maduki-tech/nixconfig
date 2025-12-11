{ pkgs, ... }:
{
  home.packages = with pkgs; [ gnome-power-manager ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 8;

        modules-left = [
          "custom/logo"
          "cpu"
          "memory"
          "temperature"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "bluetooth"
          "clock"
          "pulseaudio"
          "custom/caffeine"
          "battery"
          "custom/power"
        ];

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
          thermal-zone = 0; # AMD laptop CPU thermal zone
          critical-threshold = 85; # AMD CPUs can safely run hotter
          format = "{icon} {temperatureC}°C";
          format-icons = {
            default = "🌡️";
            critical = "🔥";
          };
          interval = 2;
          tooltip = true;
          tooltip-format = "CPU: {temperatureC}°C";
        };

        # --- Workspaces ---
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
            urgent = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
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
          format = " {:%d.%m %H:%M}";
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
            default = [
              "󰕾"
              "󰖀"
              "󰖁"
            ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip = true;
          tooltip-format = "Volume: {volume}%";
        };

        # --- Caffeine (Idle Inhibitor) ---
        "custom/caffeine" = {
          format = "{}";
          exec = "${pkgs.writeShellScript "caffeine-status" ''
            if pgrep -x hypridle > /dev/null; then
              echo '{"text": "󰅶", "class": "idle-on", "tooltip": "Idle &amp; lock enabled (click to disable)"};'
            else
              echo '{"text": "󰛊", "class": "idle-off", "tooltip": "Idle &amp; lock disabled (click to enable)"};'
            fi
          ''}";
          return-type = "json";
          interval = 5;
          on-click = "${pkgs.writeShellScript "caffeine-toggle" ''
            if pgrep -x hypridle > /dev/null; then
              pkill hypridle && ${pkgs.libnotify}/bin/notify-send "Caffeine" "Desktop will stay awake" -i preferences-desktop-screensaver
            else
              hypridle & ${pkgs.libnotify}/bin/notify-send "Caffeine" "Idle & lock re-enabled" -i preferences-desktop-screensaver
            fi
          ''}";
        };

        "battery" = {
          bat = "BAT1";
          adapter = "ACAD";
          format = "{icon}  {capacity}%";
          format-charging = " {icon} {capacity}%";
          format-icons = {
            default = "";
            "10" = "";
            "25" = "";
            "50" = "";
            "75" = "";
            "100" = "";
          };
          on-click = "gnome-power-statistics";
        };

        # --- Power Button ---
        "custom/power" = {
          format = "⏻ ";
          on-click = "wlogout";
          tooltip = true;
          tooltip-format = "Power Menu";
        };
      }
    ];

    style = builtins.readFile ./style.css;
  };
}
