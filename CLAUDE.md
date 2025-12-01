# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS system configuration repository using flakes and home-manager. The configuration is for a workstation named "uwu" running Hyprland as the window manager. The repository manages both system-level configuration (NixOS) and user-level configuration (home-manager for user "maduki").

## Architecture

### Flake Structure

The repository is organized as a NixOS flake with the following key components:

- **flake.nix**: Main entry point defining the system configuration "uwu"
  - Inputs: nixpkgs (unstable), home-manager, hyprland, zen-browser
  - Home-manager is integrated as a NixOS module, not standalone
  - User configuration is at `./home.nix` for user "maduki"

- **configuration.nix**: System-level NixOS configuration
  - Hardware imports, bootloader (GRUB on /dev/nvme0n1)
  - System packages, services, networking
  - Enables Hyprland with UWSM and Xwayland
  - Hostname: "uwu", timezone: Europe/Berlin

- **home.nix**: User-level home-manager configuration
  - User packages and development tools
  - Git configuration (user: Maduki-tech)
  - Imports modular configurations from `./programs`, `./portals`, `./theme`
  - Integrates zen-browser from flake inputs

### Module Organization

The configuration uses a modular structure with imports:

**./programs/**: Program-specific configurations
- `./programs/nvim/`: Neovim setup (includes full LazyVim configuration in `./programs/nvim/nvim/`)
- `./programs/zsh/`: Zsh shell configuration

**./portals/**: Desktop portal and window manager configurations
- `./portals/hyprland/`: Hyprland window manager configuration
  - `hyprland.nix`: Main Hyprland settings (keybinds, appearance, behavior)
  - `bindings.nix`: Additional key bindings
  - `hyprcursor.nix`: Cursor configuration

**./theme/**: Theming configuration
- GTK theme (Adwaita-dark)
- Dconf settings for GNOME desktop interface

### Key Configuration Details

**User Setup:**
- Username: maduki
- Shell: zsh
- Home directory: /home/maduki
- Groups: networkmanager, wheel

**Development Environment:**
- Languages: Node.js 24, Python 3.14, Go, Bun, Cargo
- Tools: neovim (with full treesitter grammars), gh (GitHub CLI), ripgrep, fzf
- Terminal: ghostty (primary), kitty (marked for removal)

**Hyprland Setup:**
- Dual monitor configuration (HDMI-A-1 and DP-1, both 1920x1080)
- Layout: dwindle
- VRR enabled (set to 2), VFR enabled
- Xwayland force_zero_scaling enabled
- Background manager: swww

## Common Commands

### Building and Applying Configuration

```bash
# Rebuild and switch system configuration (requires sudo)
sudo nixos-rebuild switch --flake .#uwu

# Test configuration without switching boot default
sudo nixos-rebuild test --flake .#uwu

# Build configuration without activating
sudo nixos-rebuild build --flake .#uwu

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Development and Testing

```bash
# Check Nix syntax
nix eval --file ./configuration.nix

# Check flake structure
nix flake check

# Show flake metadata
nix flake metadata

# Lint Nix files with statix (installed in home.nix)
statix check .

# Format Nix files
nix fmt
```

### Debugging

```bash
# Show build logs
sudo nixos-rebuild switch --flake .#uwu --show-trace

# Verbose output
sudo nixos-rebuild switch --flake .#uwu -v

# Check home-manager configuration
home-manager build --flake .#maduki@uwu
```

## Important Notes

- **System name**: The NixOS configuration is named "uwu" (not a hostname in the traditional sense, but the flake configuration name)
- **Flakes are enabled**: Configuration uses experimental features "nix-command" and "flakes"
- **Home-manager integration**: Home-manager runs as a NixOS module, not standalone. Changes require `sudo nixos-rebuild` to apply
- **Unfree packages**: Enabled via `nixpkgs.config.allowUnfree = true`
- **State version**: 25.05 (both system and home-manager)
- **Neovim configuration**: Full LazyVim setup located in `./programs/nvim/nvim/` directory with its own plugin management

## Adding New Modules

When adding new program configurations:

1. Create new directory under `./programs/`, `./portals/`, or `./theme/`
2. Create a `default.nix` that exports the module
3. Add import to the parent `default.nix` file
4. Reference from `home.nix` imports list if it's a user-level module

When modifying system-level settings, edit `configuration.nix` directly or create new modules imported there.
