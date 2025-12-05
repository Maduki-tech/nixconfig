{ pkgs, ... }: {
  home.packages = with pkgs; [ hyprlandPlugins.hyprsplit ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [ pkgs.hyprlandPlugins.hyprsplit ];

    settings = {
      input = {
        kb_layout = "us,de";
        kb_options = "grp:alt_shift_toggle";
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
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr =
          1; # Variable Refresh Rate - changed from 2 to 1 for better performance
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
        rounding = 6;
        blur = { enabled = false; };
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

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "noblur,class:^(com.mitchellh.ghostty)$"
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


      # in your hyprland config file:

        plugin {
            hyprsplit {
                num_workspaces = 5
                persistent_workspaces = true
            }
        }

        bind = SUPER, 1, split:workspace, 1
        bind = SUPER, 2, split:workspace, 2
        bind = SUPER, 3, split:workspace, 3
        bind = SUPER, 4, split:workspace, 4
        bind = SUPER, 5, split:workspace, 5
        bind = SUPER, 6, split:workspace, 6

        bind = SUPER SHIFT, 1, split:movetoworkspacesilent, 1
        bind = SUPER SHIFT, 2, split:movetoworkspacesilent, 2
        bind = SUPER SHIFT, 3, split:movetoworkspacesilent, 3
        bind = SUPER SHIFT, 4, split:movetoworkspacesilent, 4
        bind = SUPER SHIFT, 5, split:movetoworkspacesilent, 5
        bind = SUPER SHIFT, 6, split:movetoworkspacesilent, 6

        bind = SUPER, D, split:swapactiveworkspaces, current +1
    '';
  };

}
