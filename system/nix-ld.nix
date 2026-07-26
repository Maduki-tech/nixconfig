{ config, pkgs, ... }:

{
  # Lets dynamically-linked prebuilt binaries run unmodified on NixOS.
  # Needed for Mason-installed LSP servers/DAP adapters/formatters (from
  # the LazyVim config) which expect a standard FHS dynamic linker.
  programs.nix-ld.enable = true;
}
