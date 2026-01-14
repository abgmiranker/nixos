# To rebuild execute the following:
# sudo nixos-rebuild switch --flake <path-to-this-directory>
#
{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-nvidia.url = "github:nixos/nixpkgs/e643668fd71b949c53f8626614b21ff71a07379d";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-nvidia, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/xps/configuration.nix
        inputs.home-manager.nixosModules.default
	#{
	  #hardware.nvidia.package = 
	    # nixpkgs-nvidia.legacyPackages.x86_64-linux.linuxPackages_latest.nvidiaPackages.stable;
	    # nixpkgs-nvidia.legacyPackages.x86_64-linux.linuxPackages.nvidiaPackages.latest;
	#}
      ];
    };
  };
}
