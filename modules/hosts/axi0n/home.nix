{ self, inputs, ... }: {
  flake.homeConfigurations.miranker = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { 
      system = "x86_64-linux";
      overlays = [ inputs.nix4vscode.overlays.default ];
    };
    modules = [
      self.homeModules.mirankerConfig
      {
        home.username = "miranker";
        home.homeDirectory = "/home/miranker";
      }
    ];
  };

  flake.homeModules.mirankerConfig = { pkgs, config, ... }: {
    ##############
    ## home.nix ##
    ##############

    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];
    imports = [
      self.homeModules.d-obsidian
      self.homeModules.d-zen
      # self.homeModules.d-volumeosd

      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.modules.default
    ];

    programs.bash = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        gs = "git status";
        g8 = "git add *";
      };
      # [[ $- == *i* ]] checks if shell is interactive
      bashrcExtra = ''
        [[ $- == *i* ]] && nitch
        
        export MANPAGER="bat -plman"
        batdiff() {
          git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
        }
        '';
    };

    programs.git = {
      enable = true;
      signing.format = null;
      settings.user = {
        name = "Alex Miranker";
        email = "alex@miranker.com";
      };
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      presets = [ 
        "nerd-font-symbols" 
        "bracketed-segments"
        # "plain-text-symbols"
      ];
      settings = {
      	add_newline = false;
      };
      #settings = (with builtins; fromTOML (readFile ./starship.toml))
      # settings = (with builtins; fromTOML (readFile ./starship.toml)) // {
      #   #overrides here, may be empty
      #   add_newline = false;
      # };
    };

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
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

    home.packages = with pkgs; [ 
      btop

      nerd-fonts.monaspace
      nerd-fonts.shure-tech-mono
      nerd-fonts.hack
      # nerd-fonts.jetbrains-mono

      fastfetch
      nitch
      bat
      yazi

      inkscape
      # azahar #3ds emulator
      desmume #ds Emu
    ];
    
    home.file = {
      ".vimrc".text = ''
          syntax on

          set shiftwidth=2
          set softtabstop=2
          set smartindent

          set number

          set belloff=all
          set noerrorbells
      '';

      ".config/niri/config.kdl".source = ./config.kdl;

      ".config/niri/dms/layout.kdl".source = ./layout.kdl;
      ".config/niri/dms/binds.kdl".text = ''
        binds {
          Mod+Space hotkey-overlay-title="Application Launcher" {
            spawn "dms" "ipc" "call" "spotlight" "toggle";
          }
          Mod+Alt+L hotkey-overlay-title="Lock Screen" {
            spawn "dms" "ipc" "call" "lock" "lock";
          }
        }
      '';

      #Attempted fix for vscodium not finding extensions
      ".vscode-oss/extensions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vscode/extensions";
    };

    programs.dank-material-shell = {
      enable = true;

      plugins = {
        bongoCat.enable = true;
        sathiAi.enable = true;
        # nixMonitor = {
        #   enable = true;
        #   # storeSizeCommand = ["sh" "-c" "du -sh /nix/store 2>/dev/null | cut -f1" ];
        #   settings = {
        #     rebuildCommand = ["bash" "-c" "nixos-rebuild switch --flake $NH_FLAKE#Axi0n 2>&1"];
        #     gcCommand = ["bash" "-c" "nix-collect-garbage -d --delete-older-than 5d 2>&1"];
        #     generationsCommand = [ "bash" "-c" "ls /nix/var/nix/profiles/ | grep -c 'system-[0-9]'" ];
        #   };
        # };

        # dockerManager.enable = true;
      };
    };


    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.vimix-cursors;
      #package =
      #	inputs.futureCursors.packages."x86_64-linux".default.override
      #	{
      #	  cursorColor = "black";
      #	};
      #name = "future-cursors";
      name = "vimix-cursor";
      size = 36;
    # size = 96;
  };

    programs.ghostty = {
      enable = true;
      systemd.enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      installVimSyntax = true;
      settings = {
        theme = "dankcolors";
        # input = "fastfetch";
        background-opacity = "0.9";
        background-blur = true;
        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "5m";
      };
    };

    programs.vesktop = {
      enable = true;
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        disableMinSize = true;
        plugins = {
          FakeNitro.enabled = true;
        };
      };
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = 
        (with pkgs.vscode-extensions; [
          bbenoist.nix
          yzhang.markdown-all-in-one
          # kdl-org.kdl
        ]) ++ pkgs.nix4vscode.forVscode [ "kdl-org.kdl" ];
        # ++ pkgs.nix4vscode.forOpenVsx [ ])
    };

    programs.d-obsidian = {
      enable = true;
      vaultRepo = "git@github.com:abgmiranker/obsidian.git";
    };

    home.sessionVariables = {
      EDITOR = "vim";
      PATH = "$HOME/.local/bin:$PATH";
      # XCURSOR_THEME = "Future-cursors Black"; 
    };

    systemd.user.services.niri-floating-extensions = {
      Unit = {
        Description = "Auto-float Niri browser extension windows";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "%h/.local/bin/niri-floating-extensions";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    
    home.file.".local/bin/niri-floating-extensions" = {
    executable = true;
    text = ''
      #!/bin/bash

      ids=[]

      niri msg -j event-stream | jq --unbuffered -r ". | select ( . | has(\"WindowOpenedOrChanged\")) | .[\"WindowOpenedOrChanged\"].window | select((.title? | match(\"Extension: .* (Mozilla Firefox|Zen Browser|LibreWolf)\")) and .is_floating == false) | .id" | while read id; do
          if [[ "''${ids[*]}" == *"$id"* ]]; then
              continue
          fi

          ids+="$id"
          niri msg action toggle-window-floating --id="$id"
          niri msg action set-window-height 50%
          niri msg action set-window-width 20%
      done
    '';
    };
  };
}
