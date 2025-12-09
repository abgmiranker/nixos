{ config, pkgs, inputs, ... }:

{ 
    
  # Setup Hyprland
  programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  
  environment.systemPackage = with pkgs;[
    # Hyperland Stuff
    hyprpolkitagent
    waybar
    rofi
    mako
    libnotify
    swww
    ];
}
