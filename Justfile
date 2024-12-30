# Like Make, but It Just Works(tm)

default:
	@just --list --unsorted

########################
# Development Commands #
########################

[private]
alias rb := rebuild
# Rebuild and switch NixOS
[group('nix dev')]
rebuild:
	sudo nixos-rebuild switch

[private]
alias rbv := rebuild-v
# Rebuild and switch NixOS with verbose error logging
[group('nix dev')]
rebuild-v:
	sudo nixos-rebuild switch --show-trace -L -v

# Rebuild and switch home manager
[group('nix dev')]
home:
	home-manager switch

[private]
alias test := check
# Test flake config
[group('nix dev')]
check:
	nix flake check

[private]
alias fmt := format
# Run repo formatting
[group('nix dev')]
format:
	alejandra .

##############################
# System Management Commands #
##############################

# Quick garbage collection
[group('nix system')]
gc:
	nix-collect-garbage -d

[private]
alias disk := storage
# Print nix store disk usage
[group('nix system')]
storage:
	du -hd 0 /nix/store

######################
# System Generations #
######################

# List all generations on the system
[group('nix generation')]
list:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Switch to generation `n`
[positional-arguments]
[group('nix generation')]
@switch n:
	sudo nix-env --switch-generation $1 --profile /nix/var/nix/profiles/system

# Delete generation `n`
[positional-arguments]
[group('nix generation')]
@delete n:
	sudo nix-env --delete-generations $1 --profile /nix/var/nix/profiles/system


#################
# Miscellaneous #
#################

# Print project tree view
[group('misc')]
tree:
	tree -aI .git --noreport

