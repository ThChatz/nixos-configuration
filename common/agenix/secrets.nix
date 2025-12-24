let
  public-keys = (import ../public_keys.nix);
  everyone = [
    public-keys.tchz-yoga260.system
    public-keys.tchz-yoga260.users.tchz
    public-keys.tchz-t480.system
    public-keys.tchz-t480.users.tchz
    public-keys.tchz-vospro5402.system
    public-keys.tchz-vospro5402.users.tchz
    public-keys.tchz-macpro-51.system
    public-keys.tchz-macpro-51.users.tchz
    public-keys.tchz-pi-3p.system
    public-keys.tchz-pi-3p.users.tchz
  ];
in
{
  "tchz-password-hash.age".publicKeys = everyone;
  "gt-vpn-config.age".publicKeys = everyone;
  "git-secret-config.age".publicKeys = everyone;
}
# `agenix -r` to rekey :)
