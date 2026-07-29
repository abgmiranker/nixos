{self, inputs, ...}: 

  let
    extension = shortId: guid: {
      name = guid;
      value = {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        installation_mode = "normal_installed";
      };
    };

    extension-force = downloadUrl: guid: {
      name = guid;
      value = {
        install_url = "${downloadUrl}";
        installation_mode = "force_installed";
      };
    };

    extensions = [
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
        (extension "ublock-origin" "uBlock0@raymondhill.net")
        (extension "sponsorblock" "sponsorBlocker@ajay.app")
        (extension "tabliss" "extension@tabliss.io")
        (extension "betterttv" "firefox@betterttv.net")

        (extension-force "https://addons.mozilla.org/firefox/downloads/file/4424459/reddit_enhancement_suite-5.24.8.xpi" "jid1-xUfzOsOFlzSOXg@jetpack")
        (extension-force "https://addons.mozilla.org/firefox/downloads/file/4796063/bitwarden_password_manager-2026.4.0.xpi" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
    ];
    
    prefs = {
        # Check these out at about:config
        "extensions.autoDisableScopes" = 0;
        "extensions.pocket.enabled" = false;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # ...
    };

    mkZenPackage = pkgs: lib: 
      pkgs.wrapFirefox
        inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped
        {
          extraPrefs = lib.concatLines (
            lib.mapAttrsToList (
              name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
            ) prefs
          );

          extraPolicies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            DisplayBookmarksToolbar = true;
            OfferToSaveLogins = false;
            ExtensionSettings = builtins.listToAttrs extensions;
            SearchEngines = {
              Default = "DuckDuckGo";
              Add = [
                {
                  Name = "nixpkgs packages";
                  URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@np";
                }
                {
                  Name = "NixOS options";
                  URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@no";
                }
                {
                  Name = "NixOS Wiki";
                  URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@nw";
                }
                {
                  Name = "noogle";
                  URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                  IconURL = "https://noogle.dev/favicon.ico";
                  Alias = "@ng";
                }
                {
                  Name = "scryfall";
                  URLTemplate = "https://scryfall.com/search?q={searchTerms}";
                  IconURL = "https://scryfall.com/favicon.ico?v=58650c0ca193";
                  Alias = "@sc";
                }
              ];
              Remove = [
                "Google"
                "Bing"
                "Amazon.com"
                "eBay"
                "Twitter"
                "Perplexity"
              ];
            };
          };
        };
  in {
    flake.nixosModules.d-zen = { pkgs, lib, ... }: {
      environment.systemPackages = [ (mkZenPackage pkgs lib) ];
    };

    flake.homeModules.d-zen = { pkgs, lib, config, ... }: {
      home.packages = [ (mkZenPackage pkgs lib) ];

      # Activation script for Zen to pick up dms theme
      home.activation.linkZenTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        PROFILE_DIR=$(find "$HOME/.config/zen" -maxdepth 1 -type d -name "*.Default Profile" 2>/dev/null | head -n 1)
        if [ -n "$PROFILE_DIR" ]; then
          mkdir -p "$PROFILE_DIR/chrome"
          ln -sf "${config.xdg.configHome}/DankMaterialShell/zen.css" "$PROFILE_DIR/chrome/userChrome.css"
        else
          echo "Warning: No Zen profile directory found, skipping zen.css symlink"
        fi
      '';
    };
  }