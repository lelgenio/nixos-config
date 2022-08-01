{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    
    # my stuff
    dhist.url = "github:lelgenio/dhist";
  };
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, dhist, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        # unstable = import nixpkgs-unstable {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };
      lib = nixpkgs.lib;
      common_modules = [
        ./system/configuration.nix
        # nur.nixosModules.nur
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ 
            overlay-unstable nur.overlay
            (_: _: {
              dhist = dhist.packages.${system}.dhist;
            })
          ];
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lelgenio = import ./user/home.nix;
          home-manager.backupFileExtension = "bkp";
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    in {
      nixosConfigurations = {
        i15 = lib.nixosSystem {
          inherit system;
          modules = [ ./system/i15-hardware-configuration.nix ]
            ++ common_modules;
        };
        monolith = lib.nixosSystem {
          inherit system;
          modules = [ ./system/monolith-hardware-configuration.nix ]
            ++ common_modules;
        };
      };
    };
}
