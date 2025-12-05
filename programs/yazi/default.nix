{ ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
      };
    };

    # Set nvim as the default editor
    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "<Enter>" ];
          run = ''shell --block 'nvim "$@"' --confirm'';
          desc = "Open file with nvim";
        }
        {
          on = [ "e" ];
          run = ''shell --block 'nvim "$@"' --confirm'';
          desc = "Edit file with nvim";
        }
      ];
    };
  };

  # Set EDITOR environment variable for yazi
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
