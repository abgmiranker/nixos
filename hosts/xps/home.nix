{ config, pkgs, ... }:

let
  dotfiles = {
    vimrc = ../../dotfiles/vimrc;
};
in
{
  imports = [
    # ../../modules/starship.nix
    ../../modules/shell.nix
    # ../../modules/obsidian.nix
    ../../modules/firefox.nix
    ./niri-sh.nix
  ];

  home.username = "miranker";
  home.homeDirectory = "/home/miranker";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Qogir-cursors";
    package = pkgs.qogir-icon-theme;
    # size = 48;
    size = 96;
  };

  home.packages = with pkgs; [
    #kitty

    #Terminal Apps
    fastfetch
    nitch

    #Theme
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.agave
    nerd-fonts.shure-tech-mono

    bitwarden-desktop

    discord
    discordo
    fontpreview

    
#     mako
#     swww
#     imagemagick
  ];

  #programs.steam = {
  #  enable = true;
  #};  

  programs.kitty = {
    enable = true;
    font = {
      # name = "Agave Nerd Font";
      # name = "Hack Nerd Font";
      name = "ShureTechMono Nerd Font";
      size = 12;
    };
    extraConfig = ''
      include dank-tabs.conf
      include dank-theme.conf
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
#     bashrcExtra = ''
#       eval "$(ssh-agent -s)"
#     '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      gs = "git status";
      g8 = "git add *";
      nrs = "sudo nixos-rebuild switch";
      nrf = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos";
      # nrf = "sudo nixos-rebuild switch --flake ${env.flakePath}"
      # nrf = "echo ${env.flakePath}";
#       nrf1 = "echo ${FLAKE_PATH}";

#       k = "kubectl";
#       urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#       urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
    bashrcExtra = ''nitch'';
  };

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Alex Miranker";
    userEmail = "alex@miranker.com";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".vimrc".source = dotfiles.vimrc;
    
    "${config.xdg.configHome}" = {
      source = ../../dotfiles/dotconfig;
      recursive = true;
    };
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
    FLAKE_PATH = "${config.home.homeDirectory}/nixos";
  };

  home.activation.rebuildFontCache = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache -fv
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
