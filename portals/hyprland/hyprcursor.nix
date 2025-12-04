{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hyprcursor catppuccin-cursors.mochaMauve ];

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors"; # use the EXACT folder name
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.hyprland = {
    settings = {

      cursor = {
        enable_hyprcursor = true;
        sync_gsettings_theme = true;
        no_hardware_cursors = true;
        warp_on_change_workspace = 2;
        no_warps = false;
      };
      # Export env so Hyprland & apps pick it up consistently
      env = [
        "XCURSOR_THEME,catppuccin-mocha-mauve-cursors"
        "XCURSOR_SIZE,28"
        "HYPRCURSOR_THEME,catppuccin-mocha-mauve-cursors"
        "HYPRCURSOR_SIZE,28"
      ];

      # Optional: force-set on session start to defeat app caching
      exec-once = [ "hyprctl setcursor catppuccin-mocha-mauve-cursors 28" ];
    };
  };
}
