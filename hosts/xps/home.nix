{ config, pkgs, ... }:

{
  imports = [
    ../../modules/starship.nix
    ../../modules/shell.nix
    ../../modules/obsidian.nix
    ../../modules/firefox.nix
  ];

  home.username = "miranker";
  home.homeDirectory = "/home/miranker";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    kitty

    #Terminal Apps
    fastfetch

    #Theme
    nerd-fonts.jetbrains-mono

    bitwarden-desktop
  ];

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
      nrf = "sudo nixos-rebuild --flake '~/nixos'";
      # nrf = "sudo nixos-rebuild switch --flake ${env.flakePath}"
      # nrf = "echo ${env.flakePath}";
#       nrf1 = "echo ${FLAKE_PATH}";

#       k = "kubectl";
#       urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#       urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks.miranker.addKeysToAgent = "${config.home.homeDirectory}/.ssh/id_ed25519";
#     startAgent = true;
  };

  programs.git = {
    enable = true;
    userName = "Alex Miranker";
    userEmail = "alex@miranker.com";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
    FLAKE_PATH = "~/nixos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
