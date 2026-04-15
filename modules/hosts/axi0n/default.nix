{ self, inputs, ... }: {

  flake.nixosConfigurations.Axi0n = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.Axi0nConfig
      self.nixosModules.d-homeManager
      #{ nixpkgs.config.allowUnfree = true; }
    ];
  };

}
