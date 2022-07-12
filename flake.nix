{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        i15 = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/configuration.nix 
            ./system/i15-hardware-configuration.nix
          ];
        };        
        monolith = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/configuration.nix 
            ./system/monolith-hardware-configuration.nix
          ];
        };
      };

    };
}
