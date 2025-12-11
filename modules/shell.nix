{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI Utilities
    fzf # fuzzy find files
    btop # process monitor
    lf # file explorer
    # tldr # man page summary
    jq #JSON parser?

    #
    # neofetch
    ];


}
