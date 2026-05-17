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
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];
    imports = [
      self.homeModules.d-obsidian
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
      size = 24;
    # size = 96;
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
      azahar #3ds emulator
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
    };

    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      installVimSyntax = true;
      settings = {
        theme = "dankcolors";
        # input = "fastfetch";
        background-opacity = "0.9";
        background-blur = true;
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
      # XCURSOR_THEME = "Future-cursors Black"; 
    };
  };

}
