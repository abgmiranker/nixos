{ self, ... }: {
  flake.nixosModules.d-vim = { pkgs, config, ... }:{
    # programs.vim = {
      # enable = true;
      # defaultEditor = true;
      # settings = {
      #   expandtab = true;
      #   tabstop = 2;
      #   shiftwidth = 2;
      #   number = true;
      #   relativenumber = true;
      #   ignorecase = true;
      #   background = "dark";
      # };
      # extraConfig = ''
      #   syntax on
      #   set softtabstop=2
      #   set smartindent
        
      #   set number
      #   set cursorline
      # '';
    # };

    environment.etc."vim/vimrc".text = ''
      syntax on
      set shiftwidth=2
      set softtabstop=2
      set smartindent

      set number
      set cursorline

      set belloff=all
      set noerrorbells
    '';
  };
}
