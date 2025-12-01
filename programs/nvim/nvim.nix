{ config, lib, pkgs, pkgs-unstable, ... }:
let
	configPath = "${config.home.homeDirectory}/etc/nixos/programs/nvim/nvim";
in
{
	xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

	programs.neovim = {
		enable = true;
		viAlias = true;
		vimAlias = true;
	};
		
}
