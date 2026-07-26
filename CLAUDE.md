# NixOS Config

NixOS system configuration for hostname `nixos`, user `maduki`. Uses Nix flakes and Home Manager.

## File Structure

```
flake.nix                   # Entrypoint. Pulls in nixpkgs (unstable) and home-manager.
configuration.nix           # System entrypoint — imports hardware + system/ modules.
home.nix                    # Home Manager entrypoint — imports home/ modules.
hardware-configuration.nix  # Auto-generated hardware scan. Do not edit manually.
system/                     # NixOS system-level modules (one file per topic).
│   desktop.nix             # Hyprland, XWayland, display-related.
home/                       # Home Manager user-level modules (one file per topic).
    git.nix                 # Git config.
```

## Where Things Go

**New system-level config** → create or edit a file in `system/`, then add it to the `imports` list in `configuration.nix`.
- Services (`services.*`)
- Boot loader, kernel, hardware
- Networking
- System-wide programs that need root or affect all users (`programs.hyprland`, etc.)
- Packages that must be globally available (`environment.systemPackages`)

**New user-level config** → create or edit a file in `home/`, then add it to the `imports` list in `home.nix`.
- User packages (`home.packages`)
- Dotfiles and program configs (`programs.git`, `programs.zsh`, `programs.kitty`, etc.)
- User services (`services.syncthing`, etc.)
- Anything under `~/.config/` that Home Manager can manage

**General rule:** prefer `home/` for anything that is per-user or has a Home Manager module. Use `system/` only when a NixOS module is required or the thing needs system privileges.

## Flake Details

- **nixpkgs channel:** `nixos-unstable`
- **Home Manager:** integrated as a NixOS module (no separate `home-manager switch` needed)
- **System name:** `nixos` (matches `networking.hostName` and the flake output key)
- **Architecture:** `x86_64-linux`

## Applying Changes

```bash
# From /etc/nixos (symlink or copy files there first):
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Or directly from the repo:
sudo nixos-rebuild switch --flake /home/maduki/nixos-config#nixos
```

## Locale / Keyboard

- Timezone: `Europe/Berlin`
- Keyboard: German (`de`) — both X11 and console
- Default locale: `en_US.UTF-8`, other LC_* set to `de_DE.UTF-8`

## Desktop

- **Compositor:** Hyprland (Wayland, with XWayland enabled)
- **Terminal:** Kitty
- **Browser:** Firefox
