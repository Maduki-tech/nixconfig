# The switcher: `theme-set <name>` points every app at the chosen theme's
# pre-rendered assets (see render.nix) and reloads what can be reloaded live.
{ pkgs }:

pkgs.writeShellApplication {
  name = "theme-set";
  runtimeInputs = [ pkgs.jq pkgs.glib ];
  text = ''
    name="''${1:-}"
    if [ -z "$name" ]; then
      echo "usage: theme-set <theme-name>" >&2
      exit 1
    fi

    themedir="$HOME/.config/theme/themes/$name"
    if [ ! -d "$themedir" ]; then
      echo "unknown theme: $name" >&2
      exit 1
    fi

    ln -sfn "$themedir" "$HOME/.config/theme/current"

    # Hyprland: border/shadow colors, reload live.
    # (install, not cp: the source is a read-only /nix/store path and plain
    # cp would carry that read-only mode onto the destination, breaking the
    # *next* switch with a permission error.)
    mkdir -p "$HOME/.config/hypr"
    install -m 0644 "$themedir/hypr-theme.lua" "$HOME/.config/hypr/theme.lua"
    hyprctl reload >/dev/null 2>&1 || true

    # Neovim: regenerate the LazyVim colorscheme spec and broadcast the
    # existing LazyReload hook to every open instance (each nvim launch
    # listens on its own /tmp/nvim-<pid>.sock, see home/nvim.nix).
    nvim_theme_target="$HOME/dotfile/nvim/nvim/lua/plugins/theme.lua"
    mkdir -p "$(dirname "$nvim_theme_target")"
    install -m 0644 "$themedir/nvim-theme.lua" "$nvim_theme_target"
    for sock in /tmp/nvim-*.sock; do
      [ -S "$sock" ] || continue
      nvim --server "$sock" --remote-expr \
        "v:lua.vim.api.nvim_exec_autocmds('User', {'pattern': 'LazyReload'})" \
        >/dev/null 2>&1 || true
    done

    # GTK: live for apps that watch the setting; already-open apps mostly
    # don't repaint until restarted, that's a GTK limitation not ours.
    gsettings set org.gnome.desktop.interface gtk-theme "$(cat "$themedir/gtk-theme")" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "$(cat "$themedir/gtk-scheme")" 2>/dev/null || true

    # Obsidian: no live-reload API, this only takes effect after Ctrl+R
    # or restarting Obsidian.
    obsidian_appearance="$HOME/vault/.obsidian/appearance.json"
    if [ -f "$obsidian_appearance" ]; then
      css_theme="$(cat "$themedir/obsidian-css-theme")"
      base="$(cat "$themedir/obsidian-base")"
      tmp="$(mktemp)"
      jq --arg css "$css_theme" --arg base "$base" '.cssTheme = $css | .theme = $base' \
        "$obsidian_appearance" > "$tmp"
      mv "$tmp" "$obsidian_appearance"
    fi

    echo "theme: $name"
  '';
}
