# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  environment.systemPackages = lib.mkAfter [
    (pkgs.writeShellScriptBin "gt-vpn-enable" ''
    #!/usr/bin/env bash
    sudo -A ${pkgs.openfortivpn}/bin/openfortivpn -c ${config.age.secrets.gt-vpn-config.path}
    '')
  ];

  networking.hosts = {
    "10.128.38.93" = ["sso-test.taxydromiki.gr" "sso-test.taxydromiki.hq"];
  };

  age.identityPaths = lib.mkAfter [ "/ssh/id_ed25519" ];
  
  # graphics
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:44:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

  services.tlp = {
    enable = true;
    settings = {
      "TLP_ENABLE" = 1;
       "PLATFORM_PROFILE_ON_AC" = "performance";
       "PLATFORM_PROFILE_ON_BAT" = "low-power";
    };
  };

}
