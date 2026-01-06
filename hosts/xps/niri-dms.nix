{ config, pkgs, inputs, ... }:

{
  programs.dms-shell = {
    enable = true;
    
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
  
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;  
    # enableCalendarEvents = true;
    
    # Plugins
    #plugins = {
    #  DisplayManager = {
    #    src = pkgs.fetchFromGitHub {
	#  owner = "felri";
	#  repo = "display-manager-plugin-niri-dank-linux";
	#  tag = "v1.0.0";
	#};
      #};
      #NixMonitor = {
	#src = pkgs.fetchFromGitHub {
	 # owner = "antonjah";
	 # repo = "nix-monitor";
	 # tag = "v1.0.3";
	#};
      #};
    #};
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

    # Custom config files for non-standard config locations
    #configFiles = [
    #  "/home/miranker/.config/DankMaterialShell/settings.json"
    #];

    # Save the logs to a file
    logs = {
      save = true; 
      path = "/tmp/dms-greeter.log";
    };
  
    # Custom Quickshell Package    
    #quickshell.package = pkgs.quickshell;
};
}
