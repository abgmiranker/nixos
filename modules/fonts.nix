{config, ...}: {
  #Theme
  # nerd-fonts.jetbrains-mono
  home.packages = with pkgs; [
    #nerd-fonts.jetbrains-mono
    nerd-fonts.agave
  ];
}
