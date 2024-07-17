export NIXOS_LABEL=$$(git show HEAD -q --pretty=reference)
BOOT_ARGS=--flake . --profile-name $$(git branch --show-current)

# depend on all nix and age files tracked by git
# could maybe ignore other hosts but it may get too complicated
# and host-specific files will probably not change too often
SOURCES=$$(git ls-tree -r --name-only HEAD | grep -e ".nix" -e ".age")

test: $(SOURCES)
	nixos-rebuild test $(BOOT_ARGS) && touch test
boot: $(SOURCES)
	nixos-rebuild boot $(BOOT_ARGS) && touch boot

switch: test boot

update: flake.lock

.PHONY: flake.lock
flake.lock:
	nix flake update
