{ self, inputs, nixpkgs, ... }: 
  let
    exts = pkgs: [
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.yzhang.markdown-all-in-one
      pkgs.vscode-extensions.anthropic.claude-code
    ]; # ++ pkgs.nix4vscode.forVscode [ "kds-org.kdl" ];
  in
  {
  flake.homeModules.d-code = {pkgs, lib, config, ... }: {
    options.programs.d-code = {
      enable = lib.mkEnableOption "Enable your favorite electron-based IDE";
    };

    config = lib.mkIf config.programs.d-code.enable {
      programs.vscodium = {
        enable = true;
        profiles.default.extensions = (exts pkgs); # ++ pkgs.nix4vscode.forVscode [ "kds-org.kdl" ];
      };
    };

  };
}