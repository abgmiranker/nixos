{ self, inputs, ... }: {

  flake.nixosConfigurations.Axi0n = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.Axi0nConfig
      self.nixosModules.myHomeManager
      #{ nixpkgs.config.allowUnfree = true; }
    ];
  };

}
