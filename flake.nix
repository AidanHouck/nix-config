{
  description = "AidanHouck's NixOS Flake Config";

  inputs = {
    # Use unstable by default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Latest stable branch
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # SOPS for secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  }: {
    nixosConfigurations = {
      nixpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        # Passed downstream into modules
        specialArgs = {
          inherit inputs;

          pkgs-stable = import nixpkgs-stable {
            #inherit system;
          };
        };

        modules = [
          ./hosts/nixpi
        ];
      };
    };
  };
}
