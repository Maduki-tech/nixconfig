{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_default_text " #{pane_current_command}"
          set -g @catppuccin_window_current_text " #{pane_current_command}"
          set -g @catppuccin_window_inactive_text " #{pane_current_command}"
        '';
      }
    ];

    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color*:Tc"
      set -g allow-passthrough on

      # Unbind defaults
      unbind C-b
      unbind d

      # Prefix key
      bind-key C-a send-prefix

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf

      # VI mode bindings
      set -g status-key vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind-key v copy-mode
      bind-key p paste-buffer

      # Vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # Split panes
      bind d split-window -h
      bind V split-window -v

      # Custom session scripts
      bind-key -r f run-shell "tmux neww ~/.config/tmux/scripts/tmux-sessiongod.sh"
      bind-key -r N run-shell "~/.config/tmux/scripts/tmux-sessiongod.sh ~/dotfile/nvim/nvim"
      bind-key -r i run-shell "tmux neww ~/.config/tmux/scripts/cht.sh"

      # Status bar
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"

      # Window naming
      set-window-option -g automatic-rename off
      set -g allow-rename off
    '';
  };
  home = {

    # Install xclip for clipboard support
    packages = with pkgs; [ xclip ];
    file = {

      # Copy script files to ~/.config/tmux/scripts/
      ".config/tmux/scripts/tmux-sessiongod.sh" = {
        source = ./scripts/tmux-sessiongod.sh;
        executable = true;
      };

      ".config/tmux/scripts/cht.sh" = {
        source = ./scripts/cht.sh;
        executable = true;
      };

      ".config/tmux/scripts/tmux-cht-command" = {
        source = ./scripts/tmux-cht-command;
      };
      ".config/tmux/scripts/tmux-cht-languages" = {
        source = ./scripts/tmux-cht-languages;
      };
    };
  };
}
