{ self, inputs, ... }: 
  let
    exts = p: [
      p.vscode-extensions.bbenoist.nix
      p.vscode-extensions.yzhang.markdown-all-in-one
    ] ++ (p.nix4vscode.forVscode [ "kdl-org.kdl" ]);
  in {
    flake.homeModules.d-code = {pkgs, lib, config, ... }: {
      options.programs.d-code = {
        enable = lib.mkEnableOption "Enable your favorite electron-based IDE";

        extensions = lib.mkOption {
          type = with lib.types; listOf package;
          default = [ ];
          example = lib.literalExpression ''
            with pkgs.vscode-extensions; [ ms-python.python ]
          '';
          description = "Additional VSCodium extensions to install alongside the defaults.";
        };
      };

      config = lib.mkIf config.programs.d-code.enable {
        programs.vscodium = 
          let
            pkgOvers = import inputs.nixpkgs { 
              system = pkgs.stdenv.hostPlatform.system;
              overlays = [ inputs.nix4vscode.overlays.default ];
            };
          in {
          enable = true;
          profiles.default.extensions = (exts pkgOvers) ++ config.programs.d-code.extensions;
          # profiles.default.extensions = (exts pkgs) ++ config.programs.d-code.extensions;
        };
      };
    };
}