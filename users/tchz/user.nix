{config, pkgs, ...}:
{
  isNormalUser = true;
  description = "Theo Chatziioannidis";
  extraGroups = [ "networkmanager" "wheel" ];
  packages = with pkgs; [ emacsPackages.vterm ];
  hashedPasswordFile=config.age.secrets.tchz-password-hash.path;
} 
