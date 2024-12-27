{
  description = "AidanHouck's NixOS Flake Config";

  inputs = {
    # Use unstable by default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS for WSL
    nixpkgs-wsl-oldstable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs-wsl-oldstable";

    # SOPS for secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    nixpkgs-wsl-oldstable,
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
    
      nixos-wsl-home = nixpkgs-wsl-oldstable.lib.nixosSystem {
        specialArgs = { inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
          }
          ./hosts/nixos-wsl-home
        ];
      };
    };
    
    homeConfigurations = {
      "houck@nixpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = { inherit inputs outputs;};
        modules = [ ./modules/home ];
      };

      "houck@nixos-wsl-home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs;};
        modules = [ ./modules/home ];
      };
    };
  };
}
