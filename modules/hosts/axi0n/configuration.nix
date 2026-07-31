{ self, inputs, ... }: {
  flake.nixosModules.Axi0nConfig = { pkgs, lib, config, ... }: {
    ################
    ## config.nix ##
    ################

    imports = [
      self.nixosModules.Axi0nHardware
      self.nixosModules.d-firefox
      self.nixosModules.d-vim
      # self.nixosModules.d-zen
      self.nixosModules.d-volumeosd
      # inputs.dms-plugin-registry.modules.default
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
      extraGroups = [ "networkmanager" "wheel" "greeter" "input" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7tWDOzUMz/gWwEEfFqERL+vlOXQsmMeRbc4AqQPpju abgmiranker@icloud.com"
      ];

      packages = with pkgs; [];
    };
    home-manager.users.miranker = self.homeModules.mirankerConfig;

    security.sudo.extraConfig = ''
      Defaults env_keep += "NH_FLAKE"
      miranker ALL=(root) NOPASSWD: /run/current-system/sw/bin/nixos-rebuild switch --flake /home/miranker/nixos\#Axi0n
      miranker ALL=(root) NOPASSWD: /run/current-system/sw/bin/nix-collect-garbage -d --delete-older-than 5d
    '';

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        #X11Forwarding = false;
      };
    };

    nixpkgs.config.allowUnfree = true;

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

    #################
    ## Audio
    #################
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # Attempted fix for hyperx cloud headset
      extraConfig.pipewire = {
        "99-defaults" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 512;
            "default.clock.max-quantum" = 2048;
          };
        };
      };
      
      # Stops popping sound when speakers are unsuspended
      wireplumber.extraConfig = {
        "99-disable-suspend" = {
          "monitor.alsa.rules" = [
            {
              matches = [{ "node.name" = "~alsa_output.*"; }];
              actions.update-props."session.suspend-timeout-seconds" = 0;
            }
            {
              matches = [{ "node.name" = "~alsa_input.*"; }];
              actions.update-props."session.suspend-timeout-seconds" = 0;
            }
          ];
        };

        "50-alc897-fix" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "alsa.card_name" = "HD-Audio Generic";
                  "alsa.mixer_name" = "Realtek ALC897";
                }
              ];
              actions = {
                "update-props" = {
                  "api.acp.auto-profile" = true;
                  "api.acp.auto-port" = true;
                };
              };
            }
          ];
        };
      };
    };

    # pipewire/wireplumber config entries not writing properly. Fixing them here:
    environment.etc."wireplumber/wireplumber.conf.d/50-alc897-fix.conf".text = ''
      monitor.alsa.rules = [
        {
          matches = [
            { alsa.card_name = "HD-Audio Generic" alsa.mixer_name = "Realtek ALC897" }
          ]
          actions = {
            update-props = {
              api.acp.auto-profile = true
              api.acp.auto-port    = true
            }
          }
        }
      ]
    '';

    environment.systemPackages = with pkgs; [
      vim
      git
      #git-credential-manager
      wget
      bitwarden-cli
      yazi
      fzf
      tmux
      
      # Nix Helpers
      nh    # nh os switch ~/flake (or set $FLAKE) replaces sudo nixos-rebuild switch --flake .
      nvd   # diff sys generations like: nvd diff /nix/var/nix/profiles/system-{41,42}-link

      solaar
      pulseaudio
      xwayland-satellite
      quickshell

      fastfetch
      # monaspace
      nerd-fonts.monaspace
      vimix-cursors
      vimix-gtk-themes
      vimix-icon-theme
      tela-icon-theme

      kitty
      pkgs.protonup-qt
      # rofi-rbw
      nautilus
      # sushi
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
        NixMonitor = {
          enable = true;
          src = pkgs.fetchFromGitHub {
            owner = "antonjah";
            repo = "nix-monitor";
            rev = "v1.0.3";
            sha256 = "sha256-biRc7ESKzPK5Ueus1xjVT8OXCHar3+Qi+Osv/++A+Ls=";
          };
          # settings = {
          #   rebuildCommand = ["bash" "-c" "nixos-rebuild switch --flake /home/miranker/nixos#Axi0n 2>&1"];
          #   gcCommand = ["bash" "-c" "nix-collect-garbage -d --delete-older-than 5d 2>&1"];
          #   generationsCommand = [ "sh" "-c" "ls /nix/var/nix/profiles/ | grep -c 'system-[0-9]'" ];
          # };
        };
        # nixMonitor.enable = false;
        # bongoCat.enable = true;
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

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    environment.variables = {
      NH_FLAKE = "/home/miranker/nixos";
      XCURSOR_THEME = "vimix-cursors";
      XCURSOR_SIZE = "36";
      QS_ICON_THEME = "Tela";
      QT_QPA_PLATFORM="wayland";
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
