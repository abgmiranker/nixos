{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.dms-plugin-registry.modules.default ];
  programs.dms-shell = {
    enable = true;
    
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
  
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    # enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;  
    # enableCalendarEvents = true;
    
    # Plugins
    plugins = {
      nixMonitor.enable = true;
      dankBitwarden.enable = true;
    };
  };
  
  services.displayManager.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri"; # Required. Can be also "hyprland" or "sway"
      #customConfig = ''
	# Optional custom compositor configuration
      #'';
    };

    # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
    configHome = "/home/miranker";

    # Save the logs to a file
    logs = {
      save = true; 
      path = "/tmp/dms-greeter.log";
    };
  
    # Custom Quickshell Package    
    #quickshell.package = pkgs.quickshell;
};
}
