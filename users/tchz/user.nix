{config, pkgs, ...}:
{
  isNormalUser = true;
  description = "Theo Chatziioannidis";
  extraGroups = [ "networkmanager" "wheel" ];
  hashedPasswordFile=config.age.secrets.tchz-password-hash.path;
} 
