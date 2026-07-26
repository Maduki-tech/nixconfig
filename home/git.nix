{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "maduki";
    userEmail = "d.schlueter1011@gmail.com";
  };

  programs.gh = {
    enable = true;
  };
}
