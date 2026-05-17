{ self, inputs, ... }: {
  flake.nixosModules.Axi0nConfig = { pkgs, lib, config, ... }: {
    
    imports = [
      self.nixosModules.Axi0nHardware
      self.nixosModules.d-firefox
      inputs.dms-plugin-registry.modules.default
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.kernelPackages = pkgs.linuxPackages;
    boot.kernelPackages = pkgs.linuxPackages_latest;


    networking.hostName = "Axi0n";
    networking.networkmanager.enable = true;
    # networking.wireless.enable = true;  # wifi (wpa_supplicant)

    users.users.miranker = {
      isNormalUser = true;
      description = "Alex Miranker";
      extraGroups = [ "networkmanager" "wheel" "greeter" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7tWDOzUMz/gWwEEfFqERL+vlOXQsmMeRbc4AqQPpju abgmiranker@icloud.com"
      ];

      packages = with pkgs; [];
    };
    home-manager.users.miranker = self.homeModules.mirankerConfig;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        #X11Forwarding = false;
      };
    };

    nixpkgs.config.allowUnfree = true;
    # nixpkgs.config.nvidia.acceptLicense = true;

    hardware = {
      graphics.enable = true;
      logitech.wireless.enable = true;
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
      };
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };

    services.pulseaudio.enable = false; 
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.extraConfig."99-disable-suspend" = {
        "monitor.alsa.rules" = [
          { "node.name" = "~alsa_input.*"; }
          { "node.name" = "~alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      vim 
      git
      wget
      bitwarden-cli
      yazi
      fzf

      # Nix Helpers
      nh    # nh os switch ~/flake (or set $FLAKE) replaces sudo nixos-rebuild switch --flake .
      nvd   # diff sys generations like: nvd diff /nix/var/nix/profiles/system-{41,42}-link

      solaar
      pulseaudio
      xwayland-satellite
      quickshell

      fastfetch
      monaspace
      nerd-fonts.monaspace
      vimix-cursors
      vimix-gtk-themes
      vimix-icon-theme
      # tela-icon-theme

      kitty
      pkgs.protonup-qt
      rofi-rbw
      evtest
      # gamemode
    ];

    programs.niri = {
      enable = true;
    };

    programs.dms-shell = {
      enable = true;
      systemd.enable = true;
      systemd.restartIfChanged = true;
      
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableClipboardPaste = true;

      plugins = {
        nixMonitor.enable = true;
        bongoCat.enable = true;
        # dockerManager.enable = true;
      };
    };

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/miranker";

      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };

    #services.greetd = {
    #  enable = false;
    #  settings = {
    #    terminal.vt = 1;
    #    default_session = {
    #      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri";
    #      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember";
    #      command = "dms-greeter --command niri -C /etc/greetd/niri.kdl";
    #      user = "greeter";
    #    };
    #  };
    #};

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    programs.gamescope = {
      # gamescope -W 2560 -H 1440 -r 144 --immediate-flips -- %command% -NoStartupMovies
      enable = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    environment.variables = {
      NH_FLAKE = "/home/miranker/nixos";
      XCURSOR_THEME = "vimix-cursors";
      XCURSOR_SIZE = "48";
      QS_ICON_THEME = "Vimix-Black";
      QT_QPA_PLATFORM="wayland";
      # QT_QPA_PLATFORMTHEME="gtk3"
      QT_QPA_PLATFORMTHEME="qt6ct";
      QT_QPA_PLATFORMTHEME_QT6="qt6ct";
      ELECTRON_OZONE_PLATFORM_HINT="auto";
    };
    
    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
