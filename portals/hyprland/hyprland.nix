{ config, pkgs, ... }: {
  home.packages = with pkgs; [ swww ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      input = {
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

      general = {
        "$mainMod" = "SUPER";
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
        # col.active_border = "rgba (33 ccffee) rgba (00 ff99ee) 45 deg";
        # col.inactive_border = "rgba (595959 aa)";
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;
        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "dwindle";
      };

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = false;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr =
          2; # Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0
        force_default_wallpaper = 1;

        #  Application not responding (ANR) settings
        enable_anr_dialog = true;
        anr_missed_pings = 15;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      ecosystem = {
        no_donation_nag = true;
        no_update_news = true;
      };

      render = { direct_scanout = 0; };

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };

      # Ensure Xwayland windows render at integer scale; compositor scales them
      xwayland = { force_zero_scaling = true; };
    };
    extraConfig = ''
      monitor = HDMI-A-1, 1920x1080, 1920x0, 1
      monitor = DP-1, 1920x1080, 0x0, 1
    '';
  };

}
