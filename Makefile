export NIXOS_LABEL=$$(git show HEAD -q --pretty=reference)
BOOT_ARGS=--flake . --profile-name $$(git branch --show-current)

# depend on all nix and age files tracked by git
# could maybe ignore other hosts but it may get too complicated
# and host-specific files will probably not change too often
SOURCES=$(shell git ls-tree -r --name-only HEAD | grep -e ".nix" -e ".age")

test boot: $(SOURCES) flake.lock
# make sure i can login
	cd common/agenix && agenix -d tchz-password-hash.age > /dev/null
	nixos-rebuild $@ $(BOOT_ARGS) && touch $@

switch: test boot

update:
	nix flake update

hm-switch:
	home-manager switch --flake .

tchz-pi-3p-sd-image: $(SOURCES) flake.lock
	nix build .#images.tchz-pi-3p --option system aarch64-linux --option sandbox false

.PHONY: update tchz-pi-3p-sd-image
