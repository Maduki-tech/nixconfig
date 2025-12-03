{ pkgs, ... }: {
  # wlogout configuration
  xdg.configFile."wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "sleep 0.1 && hyprlock",
        "text" : "Lock",
        "keybind" : "l"
    }
    {
        "label" : "hibernate",
        "action" : "systemctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
    }
    {
        "label" : "logout",
        "action" : "hyprctl dispatch exit",
        "text" : "Logout",
        "keybind" : "e"
    }
    {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
    }
    {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
    }
    {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
    }

    window {
      background-color: rgba(12, 12, 12, 0.9);
    }

    button {
      border-radius: 8px;
      border: 2px solid #1e1e2e;
      background-color: #1e1e2e;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      color: #cdd6f4;
      margin: 5px;
      transition: all 0.3s ease;
    }

    button:focus,
    button:active,
    button:hover {
      background-color: #313244;
      border: 2px solid #89b4fa;
      outline-style: none;
    }

    #lock {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
    }

    #logout {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
    }

    #suspend {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
    }

    #hibernate {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
    }

    #shutdown {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
    }

    #reboot {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
    }
  '';
}
