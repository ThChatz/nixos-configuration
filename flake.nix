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

    emacs-org-config = {
      url = "github:ThChatz/emacs-org-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      # generate system definitions from directories in ./hosts
      nixosConfigurations =
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
            (lib.attrsets.attrNames (builtins.readDir ./hosts))
        );

      # generate home configuration from directories in ./
      homeConfigurations = 
        let
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
        in
        builtins.listToAttrs (
          map
            (name:
              {name = name;
               value =
                 home-manager.lib.homeManagerConfiguration {
                   inherit pkgs;
                   modules = [
                     { _module.args = inputs; }
                     { nixpkgs.overlays = [
                         inputs.emacs-org-config._overlays."x86_64-linux".default
                       ]; }
                     ./users/${name}/home.nix
                   ];
                   # Optionally use extraSpecialArgs
                   # to pass through arguments to home.nix
                 };
              })
            (nixpkgs.lib.attrsets.attrNames (builtins.readDir ./users))
        );
    };
}
