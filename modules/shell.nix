{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI Utilities
    fzf
    btop
    lf
    #

    neofetch
  ];


}
