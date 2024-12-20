{
  description = "AidanHouck's NixOS Flake Config";

  inputs = {
    # Use unstable by default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # SOPS for secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    #nixpkgs-stable,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      nixpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        # Passed downstream into modules
        specialArgs = {
          inherit inputs;
          #pkgs-stable = import nixpkgs-stable { };
        };

        modules = [
          ./hosts/nixpi
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.houck = import ./modules/home;
          }
        ];
      };
    };
  };
}
