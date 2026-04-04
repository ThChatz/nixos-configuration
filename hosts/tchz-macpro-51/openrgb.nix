{lib, pkgs, ... }:
{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };

  environment.systemPackages = lib.mkAfter [ pkgs.openrgb ];
}
