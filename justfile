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
alias hmv := home-v
# Rebuild and switch home manager with verbose error logging
[group('nix dev')]
home-v:
	home-manager switch --show-trace -L -v

[private]
alias test := check
# Test flake config
[group('nix dev')]
check:
	nix flake check

# Test flake config with verbose error logging
[group('nix dev')]
check-v:
	nix flake check --show-trace -L -v

[private]
alias shell := repl
# Enter test shell environment
[group('nix dev')]
repl:
	# ':doc builtins.x' or ':doc lib.x'
	# 'PKGNAME.meta' to view package info
	#
	# ':lf .' to load current flake
	# ':p nixosConfigurations.HOST.options.programs.PROGRAM.OPTION' to view NixOS Module options
	#
	nix repl --expr 'import <nixpkgs>{}'

[private]
alias fmt := format
# Run repo formatting
[group('nix dev')]
format:
	alejandra . 2> >(grep -v -e "Special" -e "github.com")

########################
# SOPS Secret Commands #
########################

[private]
alias ss := sops-show
# Display sops secret file
[group('sops')]
sops-show:
	sops -d secrets/secrets.yaml

[private]
alias se := sops-edit
[private]
alias sops := sops-edit
# Edit sops secret file
[group('sops')]
sops-edit:
	sops secrets/secrets.yaml || true

[private]
alias su := sops-update
# Update sops secret file with new keys in `.sops.yaml`
[group('sops')]
sops-update:
	sops updatekeys secrets/secrets.yaml

##############################
# System Management Commands #
##############################

# Update the flake.lock file
[group('nix system')]
update:
	nix flake update

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

# Grep for 'TODO' anywhere in the repo
[group('misc')]
todo:
	git grep -n TODO -- ':!modules/template.nix' ':!justfile'

# Print project tree view
[group('misc')]
tree:
	tree -aI .git --noreport

