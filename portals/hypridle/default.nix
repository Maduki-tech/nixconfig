{ pkgs, ... }: {
  # hypridle configuration - idle management daemon
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances
      before_sleep_cmd = loginctl lock-session    # lock before suspend
      after_sleep_cmd = hyprctl dispatch dpms on  # turn on display after suspend
      ignore_dbus_inhibit = false                 # whether to ignore dbus-sent idle-inhibit requests
    }

    # Dim screen after 5 minutes
    listener {
      timeout = 300                                # 5 minutes
      on-timeout = brightnessctl -s set 10%        # dim screen to 10%
      on-resume = brightnessctl -r                 # restore brightness
    }

    # Turn off screen after 10 minutes
    listener {
      timeout = 600                                # 10 minutes
      on-timeout = hyprctl dispatch dpms off       # turn off screen
      on-resume = hyprctl dispatch dpms on         # turn on screen
    }

    # Lock after 15 minutes
    listener {
      timeout = 900                                # 15 minutes
      on-timeout = loginctl lock-session           # lock screen
    }

    # Suspend after 30 minutes
    listener {
      timeout = 1800                               # 30 minutes
      on-timeout = systemctl suspend               # suspend system
    }
  '';
}
