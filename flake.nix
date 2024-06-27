{
  description = "A flake nix configuration for personal use";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # todo: use an override to put this in pkgs
    arcade-grub-theme = {
      url = "github:ThChatz/arcade-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, arcade-grub-theme }@inputs:
    {
      # generate system definitions from directories in ./hosts
      nixosConfigurations =
        builtins.listToAttrs (
          map
            (name:
              {name = name;
               value = nixpkgs.lib.nixosSystem {
                 modules = [
                   {_module.args = inputs;
                    networking.hostname="${name}"; }
                   ./hosts/${name}
                   ./common
                 ];
               };
              })
            (builtins.filter
              (dir: dir != "common")
              (nixpkgs.lib.attrsets.attrNames (builtins.readDir ./hosts)))
        );
    };
}
