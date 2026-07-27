{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "maduki";
      email = "d.schlueter1011@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
  };
}
