{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix Tooling
    alejandra
    deadnix
    statix

    fzf
    btop
    lf
  ];
}
