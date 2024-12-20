# Nix Config

foobar

## Usage

To rebuild the base system:
```
sudo nixos-rebuild switch
```

To rebuild `home-manager` packages:
```
home-manager switch --flake .
```

