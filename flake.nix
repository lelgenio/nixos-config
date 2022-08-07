{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    alacritty-sixel.url = "github:microo8/alacritty-sixel";
    alacritty-sixel.flake = false;

    ranger-sixel.url = "github:remi6397/ranger/feature/sixel";
    ranger-sixel.flake = false;

    # my stuff
    dhist.url = "github:lelgenio/dhist";
  };
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, alacritty-sixel
    , ranger-sixel, nur, dhist, ... }:
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
            overlay-unstable
            nur.overlay
            (_: old-pkgs: {
              dhist = dhist.packages.${system}.dhist;
              bmenu = import ./bmenu.nix { inherit config pkgs lib; };
              _diffr = import ./diffr.nix { inherit config pkgs lib; };
              kak-pager = import ./kak-pager.nix { inherit config pkgs lib; };
              terminal = import ./terminal.nix { inherit config pkgs lib; };
              alacritty = (old-pkgs.alacritty.overrideAttrs
                (old-alacritty: rec {
                  src = alacritty-sixel;
                  cargoDeps = old-alacritty.cargoDeps.overrideAttrs
                    (old-pkgs.lib.const {
                      inherit src;
                      outputHash =
                        "sha256-aNatd4LC4lv0bDpVfUONdtEn9OPahVBZ9ch14pWWCnM=";
                    });
                }));
              ranger = (old-pkgs.ranger.overridePythonAttrs (old-ranger: rec {
                src = ranger-sixel;
                checkInputs = [ ];
                propagatedBuildInputs = with pkgs.python3Packages;
                  old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
              }));
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
