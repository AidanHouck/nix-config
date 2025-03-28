{
  description = "AidanHouck's NixOS Flake Config";

  inputs = {
    # Use unstable by default
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Community packages for Firefox extensions
    nur.url = "github:nix-community/nur";

    # NixOS for WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # SOPS for secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Alejandra .nix formatting
    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    # Git Hooks for pre-commit formatting
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    alejandra,
    ...
  }: let
    inherit (self) outputs;
    usedSystems = ["aarch64-linux" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs usedSystems;
  in {
    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {alejandra.enable = true;};
      };
    });

    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          ./hosts/desktop
        ];
      };

      nixpi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "aarch64-linux";
        modules = [
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          ./hosts/nixpi
        ];
      };

      router = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          ./hosts/router
        ];
      };

      wsl-home = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {wsl.enable = true;}
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          ./hosts/wsl/wsl-home
        ];
      };

      wsl-work = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {wsl.enable = true;}
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          ./hosts/wsl/wsl-work
        ];
      };
    };

    homeConfigurations = {
      "houck@desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/desktop/home.nix
          {nixpkgs.overlays = [inputs.nur.overlays.default];}
        ];
      };

      "houck@nixpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./hosts/nixpi/home.nix];
      };

      "houck@router" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./hosts/router/home.nix];
      };

      "houck@wsl-home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./hosts/wsl/wsl-home/home.nix];
      };

      "houck@wsl-work" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./hosts/wsl/wsl-work/home.nix];
      };
    };
  };
}
