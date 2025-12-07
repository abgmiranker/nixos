{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix Tooling
    alejandra
    deadnix
    statix

    # CLI Utilities
    fzf
    btop
    lf
  ];
}
