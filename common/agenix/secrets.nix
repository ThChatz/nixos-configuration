let
  public-keys = (import ../public_keys.nix);
  everyone = [
    public-keys.tchz-yoga260.system
    public-keys.tchz-yoga260.users.tchz
    public-keys.tchz-t480.system
    public-keys.tchz-t480.users.tchz
    public-keys.tchz-vospro5402.system
    public-keys.tchz-vospro5402.users.tchz
  ];
in
{
  "tchz-password-hash.age".publicKeys = everyone;
  "gt-vpn-config.age".publicKeys = everyone;
}
# `agenix -r` to rekey :)
