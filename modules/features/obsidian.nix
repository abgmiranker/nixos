{ self, lib, ... }: {
    flake.homeModules.d-obsidian = { pkgs, config, ... }:{
            
        # imports = [
        #     inputs.home-manager.nixosModules.default
        # ];
        
        options.programs.d-obsidian = {
            enable = lib.mkEnableOption "Obsidian with custom settings module";
        };

        # let
        #     vaultDir = "${config.home.homeDirectory}/obsidian";
        #     vaultRepo = "git@github.com:abgmiranker/obsidian.git";
        # in
        config = lib.mkIf config.programs.d-obsidian.enable {
            programs.obsidian = {
                enable = true;
                # vaults = [
                #     "obsidian" = {
                #         enable = true;
                #         target = "./obsidian";
                #     }
                # ];
            };
            # home.activation.cloneObsidianVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            #     if [ ! -d "${vaultDir}" ]; then
            #         ${pkgs.git}/bin/git clone ${vaultRepo} "${vaultDir}"
            #     fi
            # '';
        };
    };
}
    # flake.nixosModules.d-obsidian = { pkgs, config, ... }:
    #     {
    #         options.programs.d-obsidian = {
    #             enable = lib.mkEnableOption "Obsidian with custom settings module";
    #         };
    #         config = lib.mkIf config.programs.d-obsidian.enable {
    #             packages = pkgs.obsidian;
    #             home.programs.obsidian = {
    #                 enable = true;
    #             };
    #         };
    #     };
# home-manager.users.miranker.programs.d-obsidian' does not exist