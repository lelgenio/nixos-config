{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    alacritty-sixel.url = "github:microo8/alacritty-sixel";
    alacritty-sixel.flake = false;

    ranger-sixel.url = "github:remi6397/ranger/feature/sixel";
    ranger-sixel.flake = false;

    material-wifi-icons.url = "github:dcousens/material-wifi-icons";
    material-wifi-icons.flake = false;

    # my stuff
    dhist.url = "github:lelgenio/dhist";
  };
  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nur, ... }:
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
        ./system/gitlab-runner.nix
        # nur.nixosModules.nur
        inputs.hyprland.nixosModules.default
        {
          programs.hyprland.enable = true;
          # programs.hyprland.package = null;
        }
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            overlay-unstable
            nur.overlay
            (_: old-pkgs: {
              uservars = import ./user/variables.nix;
              dhist = inputs.dhist.packages.${system}.dhist;
              alacritty = (old-pkgs.alacritty.overrideAttrs
                (old-alacritty: rec {
                  src = inputs.alacritty-sixel;
                  cargoDeps = old-alacritty.cargoDeps.overrideAttrs
                    (old-pkgs.lib.const {
                      inherit src;
                      outputHash =
                        "sha256-aNatd4LC4lv0bDpVfUONdtEn9OPahVBZ9ch14pWWCnM=";
                    });
                }));
              ranger = (old-pkgs.ranger.overridePythonAttrs (old-ranger: rec {
                src = inputs.ranger-sixel;
                checkInputs = [ ];
                propagatedBuildInputs = with old-pkgs.python3Packages;
                  old-ranger.propagatedBuildInputs ++ [ astroid pylint pytest ];
              }));
              material-wifi-icons = pkgs.stdenv.mkDerivation rec {
                name = "material-wifi-icons";
                src = inputs.material-wifi-icons;
                installPhase = let dest = "$out/share/fonts/${name}";
                in ''
                  mkdir -p ${dest}
                  cp material-wifi.ttf ${dest}
                '';
              };
              papirus_red =
                (pkgs.unstable.papirus-icon-theme.override { color = "red"; });
              orchis_theme_compact = (pkgs.orchis-theme.override {
                tweaks = [ "compact" "solid" ];
              });
              nerdfonts_fira_hack =
                (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
              volumesh = pkgs.writeShellScriptBin "volumesh"
                (builtins.readFile ./user/scripts/volumesh);
            })
            (import ./scripts { inherit config pkgs lib; })
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
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    in {
      nixosConfigurations = {
        i15 = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/i15.nix ] ++ common_modules;
        };
        monolith = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/monolith.nix ] ++ common_modules;
        };
      };
    };
}
