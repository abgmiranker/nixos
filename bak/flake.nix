# To rebuild execute the following:
# sudo nixos-rebuild switch --flake <path-to-this-directory>
#
{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-nvidia.url = "github:nixos/nixpkgs/e643668fd71b949c53f8626614b21ff71a07379d";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    futureCursors = {
      url = "github:Tukankamon/Future-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    #nix-monitor = {
    #  url = "github:antonjah/nix-monitor";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/xps/configuration.nix
        inputs.home-manager.nixosModules.default
	#nix-monitor.nixosModules.default
	#{
	#  programs.nix-monitor = {
	#  enable = true;
        #  rebuildCommand = [ "bash" "-c" "sudo nixos-rebuild switch --flake .#nixos 2>&1" ];
	#  };
	#}
      ];
    };
  };
}
