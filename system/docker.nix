{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users."maduki".extraGroups = [ "docker" ];
}
