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
    home-manager,
    ...
  }: let 
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nixpi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs;};
        system = "aarch64-linux";
        modules = [ ./hosts/nixpi ];
      };
    };
    
    homeConfigurations = {
      "houck@nixpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = { inherit inputs outputs;};
        modules = [ ./modules/home ];
      };
    };
  };
}
