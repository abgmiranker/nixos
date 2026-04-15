{ config, pkgs, lib, ... }:

let
  vaultDir = "${config.home.homeDirectory}/obsidian";
  vaultRepo = "git@github.com:abgmiranker/obsidian.git";
in
{
  home.packages = [ pkgs.obsidian ];

  home.activation.cloneObsidianVault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${vaultDir}" ]; then
      ${pkgs.git}/bin/git clone ${vaultRepo} "${vaultDir}"
    fi
  '';
}
