let
  public-keys = (import ../public_keys.nix);
in
{
  "tchz-password-hash.age".publicKeys = [
    public-keys.tchz-yoga260.system
    public-keys.tchz-yoga260.users.tchz
    public-keys.tchz-t480.system
  ];
}
# `agenix -r` to rekey :)
