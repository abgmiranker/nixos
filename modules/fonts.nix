{config, ...}:
{
  home.packages = with pkgs; [
    #nerd-fonts.jetbrains-mono
    nerd-fonts.agave
  ];
}
