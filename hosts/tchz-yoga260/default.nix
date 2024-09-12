# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, lib, arcade-grub-theme, ... }:
  {
    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
      ];

    services.snapper = {
      configs = {
        tchz = {
          SUBVOLUME = "/home/tchz";
          ALLOW_USERS = [ "tchz" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = 24;
          TIMELINE_LIMIT_DAILY = 15;
          TIMELINE_LIMIT_WEEKLY = 3;
          TIMELINE_LIMIT_MONTHLY = 24;
          TIMELINE_LIMIT_YEARLY = 100;
        };
      };
    };

    # networking.hostName = lib.mkForce "tchz-yoga260"; # Define your hostname.
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = lib.mkForce "23.05"; # Did you read the comment?
  }
