{ ... }: {

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # custom settings
    settings = {
      add_newline = true;
      line_break.disabled = false;
    };
  };

  programs.zsh = {
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

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 18;
      font-family = "JetBrainsMono Nerd Font";
      background-opacity = 0.8;
      window-padding-x = 8;
      window-padding-y = 8;
    };
  };
}
