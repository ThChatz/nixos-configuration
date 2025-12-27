{config, pkgs, ...}:
{
  isNormalUser = true;
  description = "Theo Chatziioannidis";
  extraGroups = [ "networkmanager" "wheel" "docker" ];
  hashedPasswordFile=config.age.secrets.tchz-password-hash.path;
  openssh.authorizedKeys.keys = (import ../../common/public_keys.nix).everyone;
}
