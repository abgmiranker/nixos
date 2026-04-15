{ self, inputs, ... }: {

  flake.nixosModules.Axi0nHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports =[
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    # boot.initrd.kernelModules = [ "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelModules = [ "kvm-amd" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    # boot.kernelModules = [ "kvm-amd" ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
    boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d669237a-ba1f-4eaa-995e-c620b5d756b0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/670D-B464";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/27b33a0f-e972-4042-aeaa-6bf8e8d6fffd"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };
}
