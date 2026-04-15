{config, ...}:
{
  home.packages = with pkgs; [
    #nerd-fonts.jetbrains-mono
    nerd-fonts.agave
    nerd-fonts.hack
    
    #nerd-fonts.monaspace
  ];
}
