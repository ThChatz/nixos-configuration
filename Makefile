export NIXOS_LABEL=$$(git show HEAD -q --pretty=reference)
BOOT_ARGS=--flake . --profile-name $$(git branch --show-current)

# depend on all nix and age files tracked by git
# could maybe ignore other hosts but it may get too complicated
# and host-specific files will probably not change too often
SOURCES=$(shell git ls-tree -r --name-only HEAD | grep -e ".nix" -e ".age")

test boot: $(SOURCES) flake.lock
	nixos-rebuild $@ $(BOOT_ARGS) && touch $@

switch: test boot

update: flake.lock

hm-switch:
	home-manager switch --flake .


.PHONY: flake.lock all
flake.lock:
	nix flake update
