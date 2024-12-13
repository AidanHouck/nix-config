{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        # Import the previous configuration.nix
        ./configuration.nix
      ];
    };
  };
}
