{config, ...}: {
  # home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    # enableZshIntegration = true;
    # enableNushellIntegration = true;
    # settings = {
    #   character = {
    #     success_symbol = "[›](bold green)";
    #     error_symbol = "[›](bold red)";
    #   };
    # };
  };
}
