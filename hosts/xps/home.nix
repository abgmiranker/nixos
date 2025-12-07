{ config, pkgs, ... }:

{
  imports = [
    ../../modules/starship.nix
    ../../modules/shell.nix
  ];

  home.username = "miranker";
  home.homeDirectory = "/home/miranker";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    #Terminal Apps
    fastfetch
    #tree

    #Theme
    nerd-fonts.jetbrains-mono

    #GUI Apps
    obsidian
    bitwarden-desktop
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
#    bashrcExtra = ''
#      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
#    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      gs = "git status";
      nrs = "sudo nixos-rebuild switch";
      # nrf = "sudo nixos-rebuild switch --flake ${env.flakePath}"
      nrf = "echo ${flakePath}";
      nrf1 = "echo ${FLAKE_PATH}";

#       k = "kubectl";
#       urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#       urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  programs.ssh.startAgent = true;

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/miranker/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    FLAKE_PATH = "~/nixos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
