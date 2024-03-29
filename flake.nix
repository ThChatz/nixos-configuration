{
  description = "flake for tchz-thinkpad";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    arcade-grub-theme = {
      url = "github:ThChatz/arcade-grub-theme/58223a4";
    };
  };

  outputs = { self, nixpkgs, arcade-grub-theme }@inputs: {
    nixosConfigurations = {
      tchz-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = inputs;
          }
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
  };
}
