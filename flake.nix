{
  description = "A flake nix configuration for personal use";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    arcade-grub-theme = {
      url = "github:ThChatz/arcade-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, arcade-grub-theme }@inputs:
    {
    nixosConfigurations = {
      tchz-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = inputs;
          }
          ./hosts/tchz-yoga260/configuration.nix
          ./hosts/tchz-yoga260/hardware-configuration.nix
          ./modules/configuration.nix
        ];
      };

      tchz-t480 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = inputs;
          }
          ./configuration.nix
          ./tchz-t480/hardware-configuration.nix
        ];
      };
    };
  };
}
