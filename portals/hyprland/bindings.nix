{ host, pkgs, ... }: {
  home.packages = with pkgs; [ wl-clipboard playerctl ];
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
      "$mainMod, Return, exec, ghostty"
      "$mainMod, SPACE, exec, rofi -show drun"
      "$mainMod, B, exec, zen"
      "$mainMod, Q, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, L, exec, hyprlock"
      "$mainMod, Escape, exec, wlogout"

      "$mainMod, V, togglefloating,"
      "$mainMod, F, fullscreen, 1"

      # Wallpaper controls
      "$mainMod, W, exec, wallsetter"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9] (split-monitor-workspaces)
      # "$mainMod, 1, split-workspace, 1"
      # "$mainMod, 2, split-workspace, 2"
      # "$mainMod, 3, split-workspace, 3"
      # "$mainMod, 4, split-workspace, 4"
      # "$mainMod, 5, split-workspace, 5"
      # "$mainMod, 6, split-workspace, 6"
      # "$mainMod, 7, split-workspace, 7"
      # "$mainMod, 8, split-workspace, 8"
      # "$mainMod, 9, split-workspace, 9"
      # "$mainMod, 0, split-workspace, 10"
      #
      # # Move active window to a workspace with mainMod + SHIFT + [0-9] (split-monitor-workspaces)
      # "$mainMod SHIFT, 1, split-movetoworkspace, 1"
      # "$mainMod SHIFT, 2, split-movetoworkspace, 2"
      # "$mainMod SHIFT, 3, split-movetoworkspace, 3"
      # "$mainMod SHIFT, 4, split-movetoworkspace, 4"
      # "$mainMod SHIFT, 5, split-movetoworkspace, 5"
      # "$mainMod SHIFT, 6, split-movetoworkspace, 6"
      # "$mainMod SHIFT, 7, split-movetoworkspace, 7"
      # "$mainMod SHIFT, 8, split-movetoworkspace, 8"
      # "$mainMod SHIFT, 9, split-movetoworkspace, 9"
      # "$mainMod SHIFT, 0, split-movetoworkspace, 10"
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
