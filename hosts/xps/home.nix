{ config, pkgs, inputs, ... }:

let
  #future-cursors = pkgs.callPackage ../../pkgs/future-cursors.nix {};
  dotfiles = {
    vimrc = ../../dotfiles/vimrc;
  };
in
{
  imports = [
    # ../../modules/starship.nix
    ../../modules/shell.nix
    #../../modules/obsidian.nix
    ../../modules/firefox.nix
    ./niri-sh.nix
  ];

  home.username = "miranker";
  home.homeDirectory = "/home/miranker";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  #home.pointerCursor = {
  #  gtk.enable = true;
  #  x11.enable = true;
  #  name = "Future-cursors Black";
  #  package = future-cursors;
  #  #size = 48;
  #  size = 64;
  #};
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package =
      inputs.futureCursors.packages."x86_64-linux".default.override
      {
        cursorColor = "black";
      };
    name = "future-cursors";
    # size = 48;
    size = 96;
  };

  home.packages = with pkgs; [
    #kitty

    #Terminal Apps
    fastfetch
    nitch
    bat
    yazi

    #Theme
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.agave
    nerd-fonts.shure-tech-mono
    nerd-fonts.monaspace

    bitwarden-desktop
    kando
    
    #discord
#    discordo
#    fontpreview

#    ghostty
    inkscape
#    gimp2 
#    imagemagick
  ];

  #programs.steam = {
  #  enable = true;
  #};  
programs.kitty = {
    enable = false;
    font = {
      # name = "Hack Nerd Font";
      # name = "ShureTechMono Nerd Font";
      # name = "Monaspace Nerd Font"
      name = "MonaspiceKr Nerd Font";
       size = 12;
    };
    extraConfig = ''
      include dank-tabs.conf
      include dank-theme.conf
    '';
};

programs.ghostty = {
  enable = true;
  settings = {
    #name = "ShureTechMono Nerd Font";
    #font-family = "";
    #name = "ShureTechMono Nerd Font";
    font-family = "MonaspiceKr Nerd Font";
    
    font-size = 12;
    theme = "dankcolors";
    app-notifications = "no-clipboard-copy,no-config-reload"; 
  };
};

programs.yazi = {
  enable = true;
  settings = {
    mgr = {
      ratio = [1 3 4];
      show_hidden = false;    

    };
    preview = {
      wrap = "no";
    };

  };
};

programs.starship = {
    enable = false;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      #format = lib.concatStrings [
	#"$line_break"
	#"$package"
	#"$line_break"
	#"$character"
	#];
      #scan_timeout = 10;
      #character = {
#	success_symbol = "➜";
#	error_symbol = "➜";
#      };
    };
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
      nxs = "sudo nixos-rebuild switch";
      nrf = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos";
      nxf = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos";

      nix-h = "man 5 configuration.nix";
      nxopts = "man 5 configuration.nix";
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
    # XCURSOR_THEME = "Future-cursors Black";
  };

  home.activation.rebuildFontCache = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache -fv
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
