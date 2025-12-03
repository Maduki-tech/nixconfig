{ config, ... }:
let basePath = "${config.home.homeDirectory}/etc/nixos";
in {
  # hyprlock configuration
  xdg.configFile."hypr/hyprlock.conf".text = ''
    # BACKGROUND
    background {
      monitor =
      path = ${basePath}/backgrounds/bg1.jpg
      blur_passes = 3
      blur_size = 8
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    # GENERAL
    general {
      no_fade_in = false
      grace = 0
      disable_loading_bar = false
    }

    # INPUT FIELD
    input-field {
      monitor =
      size = 250, 60
      outline_thickness = 2
      dots_size = 0.2
      dots_spacing = 0.2
      dots_center = true
      outer_color = rgba(0, 0, 0, 0)
      inner_color = rgba(0, 0, 0, 0.5)
      font_color = rgb(200, 200, 200)
      fade_on_empty = false
      font_family = JetBrains Mono Nerd Font
      placeholder_text = <i><span foreground="##cdd6f4">Enter Password...</span></i>
      hide_input = false
      position = 0, -120
      halign = center
      valign = center
    }

    # DATE
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%A, %B %d")"
      color = rgba(242, 243, 244, 0.75)
      font_size = 22
      font_family = JetBrains Mono Nerd Font
      position = 0, 300
      halign = center
      valign = center
    }

    # TIME
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%H:%M")"
      color = rgba(242, 243, 244, 0.75)
      font_size = 95
      font_family = JetBrains Mono Nerd Font Mono ExtraBold
      position = 0, 200
      halign = center
      valign = center
    }

    # USER
    label {
      monitor =
      text = Hi, $USER
      color = rgba(242, 243, 244, 0.75)
      font_size = 25
      font_family = JetBrains Mono Nerd Font
      position = 0, -40
      halign = center
      valign = center
    }

    # KEYBOARD LAYOUT
    label {
      monitor =
      text = cmd[update:1000] echo "$(hyprctl devices | grep 'active keymap' | sed 's/active keymap: //' | head -n 1)"
      color = rgba(242, 243, 244, 0.75)
      font_size = 14
      font_family = JetBrains Mono Nerd Font
      position = 0, -200
      halign = center
      valign = center
    }
  '';
}
