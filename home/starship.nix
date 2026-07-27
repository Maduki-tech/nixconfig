{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      format = builtins.concatStringsSep "" [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$bun"
        "$python"
        "$rust"
        "$golang"
        "$lua"
        "$nix_shell"
        "$character"
      ];

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        truncation_length = 3;
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
      };

      bun = {
        symbol = "🥟 ";
        format = "[$symbol($version )]($style)";
        style = "bold red";
      };

      python = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
      };

      rust = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
      };

      golang = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
      };

      lua = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
      };

      nix_shell = {
        symbol = " ";
        format = "[$symbol$state]($style) ";
      };
    };
  };
}
