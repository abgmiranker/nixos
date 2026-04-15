{ config, pkgs, lib, ... }: {
    flake.homeModules.d-obsidian = { pkgs, lib, config, ... }:

    let
        vaultDir = "${config.home.homeDirectory}/obsidian";
        vaultRepo = "git@github.com:abgmiranker/obsidian.git";
    in
    {
        # imports = [
        #     inputs.home-manager.nixosModules.default
        # ];
        
        home.packages = [ pkgs.obsidian ];

        home.activation.cloneObsidianVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ ! -d "${vaultDir}" ]; then
            ${pkgs.git}/bin/git clone ${vaultRepo} "${vaultDir}"
            fi
        '';
    };
}
