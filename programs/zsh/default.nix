{ ... }: {
  programs = {
    # starship - an customizable prompt for any shell
    starship = {
      enable = true;
      enableZshIntegration = true;
      # custom settings
      settings = {
        add_newline = true;
        line_break.disabled = false;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = { enable = true; };
      syntaxHighlighting.enable = true;
      shellAliases = {
        nixconf = "nvim ~/etc/nixos";
        nixbuild = "sudo nixos-rebuild switch --flake ~/etc/nixos#uwu";
      };
      oh-my-zsh = {
        enable = true;
        theme = "avit";
        plugins = [ "git" "z" "sudo" "extract" "colored-man-pages" "colorize" ];
      };
    };

    ghostty = {
      enable = true;
      settings = {
        font-size = 18;
        font-family = "JetBrainsMono Nerd Font";
        background-opacity = 0.9;
        window-padding-x = 8;
        window-padding-y = 8;
        confirm-close-surface = false;
      };
    };
  };
}
