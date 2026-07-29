{ config, pkgs, ... }: {
  flake.nixosModules.d-vim = { pkgs, config, lib, ... }:{
    programs.vim = {
      enable = true;
      defaultEditor = true;
      settings = {
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        number = true;
        relativenumber = true;
        ignorecase = true;
        background = "dark";
      };
      extraConfig = ''
        syntax on
        set softtabstop=2
        set smartindent
        
        set number
        set cursorline
      '';
    };
  }
}
