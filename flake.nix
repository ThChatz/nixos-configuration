{
  description = "A flake nix configuration for personal use";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # todo: use an overlay to put this in pkgs or switch to non-flake solution
    arcade-grub-theme = {
      url = "github:ThChatz/arcade-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, arcade-grub-theme, agenix, home-manager }@inputs:
    {
      # generate system definitions from directories in ./hosts
      nixosConfigurations =
        let
          lib = nixpkgs.lib;
        in
        builtins.listToAttrs (
          map
            (name:
              {name = name;
               value = lib.nixosSystem {
                 modules = [
                   {_module.args = inputs;
                    networking.hostName = lib.mkForce "${name}";}
                   ./hosts/${name}
                   ./common
                   agenix.nixosModules.default
                 ];
               };
              })
            (nixpkgs.lib.attrsets.attrNames (builtins.readDir ./hosts))
        );
    };
}
