# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
    age.identityPaths = lib.mkAfter [ "/ssh/id_rsa" ];
    system.stateVersion = "24.05"; # Did you read the comment?
}

