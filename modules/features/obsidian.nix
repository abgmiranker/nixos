{ self, ... }: {
    flake.homeModules.d-obsidian = { pkgs, lib, config, ... }:{
        
        options.programs.d-obsidian = {
            enable = lib.mkEnableOption "Obsidian with custom settings module";

            vaultRepo = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "git@github.com:abgmiranker/obsidian.git";
                description = "Remote repo to fetch vault from if not found";
            };

            vaultDir = lib.mkOption {
                type = lib.types.str;
                default = "${config.home.homeDirectory}/obsidian";
                example = "/path/to/your/vault";
                description = "Directory of your vault";
            };
        };

        config = lib.mkIf config.programs.d-obsidian.enable {
            programs.obsidian = {
                enable = true;
                vaults.obsidian = {
                    enable = true;
                };
            };
            home.activation.cloneObsidianVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                if [ ! -d "${config.programs.d-obsidian.vaultDir}" ]; then
                    export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh"
                    run ${pkgs.git}/bin/git clone ${config.programs.d-obsidian.vaultRepo} "${config.programs.d-obsidian.vaultDir}"
                fi
            '';
        };
    };
}
