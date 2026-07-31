{ self, ... }: {
  flake.homeModules.d-yazi = { pkgs, lib, config, ... }: 
    let 
      cfg = config.programs.d-yazi;
    in {
      options.programs.d-yazi = {
          enable = lib.mkEnableOption "Enable yazi (terminal file manager)";

          previewerSuite = lib.mkOption {
            type = lib.types.enum [ "none" "some" "all" ];
            default = "none";
            example = "all";
            description = ''
              Which optional tools should be installed to extend yazi's previewer?
              Selecting 'some' will install jq, resvg only.
              Selecting 'all' will install jq, resvg, ffmpeg, poppler, and ImageMagick. 
              Does not install any additional packages by default. Leave this option empty and install these packages manually for fine-grained control. List of optional tools can be found here: https://yazi-rs.github.io/docs/installation"
            '';
          };
      };

      config = lib.mkIf cfg.enable {
        
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";
          settings = {
            mgr = {
              ratio = [1 3 4];
              linemode = "size";
              show_hidden = false;    
            };
            preview = {
              wrap = "no";
            };
          };
        };

        home.packages = [] ++
        (if (cfg.previewerSuite == "some")
          then [
            pkgs.jq
            pkgs.resvg
          ]
        else 
          (if (cfg.previewerSuite == "all")
            then [
              pkgs.jq
              pkgs.resvg
              pkgs.ffmpeg
              pkgs.poppler
              pkgs.imagemagick
            ]
            else []));

      };
    };
}