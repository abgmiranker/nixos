{ self, ... }: {
  flake.homeModules.d-code = { pkgs, lib, ... }: {

  
    options.programs.d-code = {
      enable = lib.mkEnableOption "Enable your favorite electron-based IDE";



    }
    
    config = lib.mkIf config.programs.d-code.enable {
      nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];
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
    }
  }
}