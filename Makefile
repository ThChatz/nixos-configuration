export NIXOS_LABEL=$$(git show HEAD -q --pretty=reference)
REBUILD_ARGS=--flake . --profile-name $$(git branch --show-current)

test:
	sudo -A nixos-rebuild test --flake .

switch: flake.nix flake.lock
	sudo -A nixos-rebuild switch $(REBUILD_ARGS) && touch switch

update: flake.lock

flake.lock:
	nix flake update
