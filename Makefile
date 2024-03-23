test:
	sudo -A nixos-rebuild test --flake .

switch:
	sudo -A nixos-rebuild switch --flake .

update: flake.lock

flake.lock:
	nix flake update
