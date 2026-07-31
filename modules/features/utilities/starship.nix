{ self, ... }: {
  flake.homeModules.d-starship = { pkgs, lib, config, ... }:
  
  let
    cfg = config.programs.d-starship;
  in {
    options.programs.d-starship = {
        enable = lib.mkEnableOption "Starship terminal prompt with custom settings module";

        plainTextSymbols = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Should starship use only symbols that appear in plain text?";
        };
    };

    config = lib.mkIf cfg.enable {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        presets = if cfg.plainTextSymbols
          then [ "plain-text-symbols" "bracketed-segments" ]
          else [ "nerd-font-symbols" "bracketed-segments" ];
        settings = {
          add_newline = false;
        };
      };
    };
  };
}