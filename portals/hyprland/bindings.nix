{ host, pkgs, ... }: {
  home.packages = with pkgs; [ wl-clipboard playerctl ];
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod, Return, exec, ghostty"
      "$mainMod, SPACE, exec, rofi -show drun"
      "$mainMod, B, exec, zen"
      "$mainMod, Q, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, L, exec, hyprlock"
      "$mainMod, Escape, exec, wlogout"
      # Terminal UI's
      "$mainMod, E, exec, ghostty -e yazi"
      "$mainMod, T, exec, ghostty -e btop"
      "$mainMod, D, exec, ghostty -e lazydocker"

      "$mainMod, V, togglefloating,"
      "$mainMod, F, fullscreen, 1"

      # Wallpaper controls
      "$mainMod, W, exec, wallsetter"

      # Keyboard layout switching
      "$mainMod, K, exec, hyprctl switchxkblayout all next"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ];

    bindm =
      [ "$mainMod, mouse:272, movewindow" "$mainMod, mouse:273, resizewindow" ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"

      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

  };
}
