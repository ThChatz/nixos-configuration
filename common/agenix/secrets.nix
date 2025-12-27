let
  public-keys = (import ../public_keys.nix);
in
{
  "tchz-password-hash.age".publicKeys = public-keys.everyone;
  "gt-vpn-config.age".publicKeys = public-keys.everyone;
  "git-secret-config.age".publicKeys = public-keys.everyone;
}
# `agenix -r` to rekey :)
