test:
	sudo -A nixos-rebuild test --flake .

switch: configuration.nix hardware-configuration.nix flake.nix flake.lock
	sudo -A nixos-rebuild switch --flake . --profile-name $$(git branch --show-current) && touch switch

update: flake.lock

flake.lock:
	nix flake update
