{ self, ... }: {
  flake.homeModules.d-code = {pkgs, lib, config, ... }: 
  let
    cfg = config.programs.d-code;
  in {
    options.programs.d-code = {
      enable = lib.mkEnableOption "Enable your favorite electron-based IDE";
    };
    config = lib.mkIf cfg.enable {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default.extensions = (with pkgs.vscode-extensions; [
          bbenoist.nix
          yzhang.markdown-all-in-one
        ]);
        # ++ pkgs.nix4vscode.forVscode [ "kds-org.kdl" ];
        # ++ pkgs.nix4vscode.forOpenVsx [ ])
      };
    };
  };
}