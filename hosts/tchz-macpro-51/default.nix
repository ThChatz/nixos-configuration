# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./autorandr.nix
      ./nvidia.nix
      ./openrgb.nix
    ];
  
  environment.systemPackages = lib.mkAfter (with pkgs; [
    vulkan-tools
  ]);
  
  age.identityPaths = lib.mkAfter [ "/ssh/id_rsa" ];
  system.stateVersion = "24.05"; # Did you read the comment?
}

