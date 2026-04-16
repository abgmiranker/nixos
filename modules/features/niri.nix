{ self, inputs, ... }: {
    # flake.nixosModules.d-niri = { pkgs, lib, ... }: {
    #     programs.niri = {
    #         enable = true;
    #         package = self.packages.${pkgs.stdenv.hostPlatform.system}.d-niri;
    #     };
    # };
    # perSystem = { pkgs, ... }: {
    #     packages.d-niri = inputs.wrapper-modules.wrappers.niri.wrap {
    #         inherit pkgs;
    #         settings = {
    #             input = {
    #                 keyboard.xkb.options = "caps:escape";
    #                 mouse = {
    #                     accel-speed = "-0.75";
    #                     accel-profile = "adaptive";
    #                 };
    #             };
    #             binds = {
    #                 "Mod+T".spawn = pkgs.ghostty;
    #                 "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;

    #                 "Mod+Q".close-window = null;
    #                 "Mod+O".toggle-overview = null;
    #                 "KP_Add".toggle-overview = null;

    #                 # XF86AudioRaiseVolume allow-when-locked=true { spawn "volumeosd" "up"; }
    #                 # XF86AudioLowerVolume allow-when-locked=true { spawn "volumeosd" "down"; }
    #                 # XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
                    
    #                 # "Mod+Shift+E".spawn-sh = ''${config.pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe config.pkgs.swappy} -f -'';
    #                 "Mod+BracketLeft".consume-or-expel-window-left = null;
    #                 "Mod+BracketRight".consume-or-expel-window-right = null;
                    
    #                 "Mod+R".switch-preset-column-width = null;
    #                 "Mod+Shift+R".switch-preset-window-height = null;
    #                 "Mod+Ctrl+R".reset-window-height = null;
                    
    #                 "Mod+F".maximize-column = null;
    #                 "Mod+Shift+F".fullscreen-window = null;
    #                 "Mod+Ctrl+F".expand-column-to-available-width = null;
                    
    #                 "Mod+C".center-column = null;
    #                 "Mod+Ctrl+C".center-visible-columns = null;

    #                 "Mod+V".toggle-window-floating = null;
    #                 "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;
    #             }
    #             # spawn-at-startup = [
    #             #     noctaliaExe
    #             #         (lib.getExe (
    #             #             pkgs.writeShellScriptBin "wallpaper"
    #             #             "${lib.getExe pkgs.swaybg} -i ${self.wallpaper} -m fill"
    #             #         ))
    #             # ];
    #         };
    #     };
    # };
}