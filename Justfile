# Like Make, but It Just Works(tm)

default:
  @just --list

########################
# Development Commands #
########################

# Rebuild and switch NixOS
[group('nix dev')]
rebuild:
  sudo nixos-rebuild switch

# Rebuild and switch NixOS with verbose error logging
[group('nix dev')]
rebuild-v:
  sudo nixos-rebuild switch --show-trace -L -v

# Rebuild and switch home manager
[group('nix dev')]
home:
  home-manager switch

# Test flake config
[group('nix dev')]
check:
  nix flake check

# Run Alejandra formatting tests
[group('nix dev')]
format:
  alejandra .


##############################
# System Management Commands #
##############################

# Quick garbage collection
[group('nix sys')]
gc:
  nix-collect-garbage -d

# List all generations on the system
[group('nix sys')]
list:
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Switch to generation <N>
[positional-arguments]
[group('nix sys')]
@switch n:
  sudo nix-env --switch-generation $1 --profile /nix/var/nix/profiles/system
