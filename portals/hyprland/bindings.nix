{ host, pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    playerctl
  ];
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
      "$mainMod, F11, fullscreen, "

      # Keyboard layout switching
      "$mainMod, K, exec, hyprctl switchxkblayout all next"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    gesture = [
      "3, horizontal, workspace"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness (with SwayOSD)
      ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

  };
}
