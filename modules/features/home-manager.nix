{ self, inputs, ... }: {  
  
  flake.nixosModules.d-homeManager = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    # nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.bak"; 
    };
  };

}
