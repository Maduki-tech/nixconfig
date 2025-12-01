{ config, ... }:
let basePath = "${config.home.homeDirectory}/etc/nixos";
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${basePath}/backgrounds/bg1.jpg" ];
      wallpaper = [ ", ${basePath}/backgrounds/bg1.jpg" ];

    };
  };

}
