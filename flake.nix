{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    # mpvpaper
    wegank = {
      url = "github:wegank/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    alacritty-sixel.url = "github:ayosec/alacritty";
    alacritty-sixel.flake = false;

    ranger-sixel.url = "github:remi6397/ranger/feature/sixel";
    ranger-sixel.flake = false;

    ranger-icons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-icons.flake = false;

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
      lib = nixpkgs.lib;
      common_modules = [
        ./system/configuration.nix
        ./system/sway.nix
        ./system/gitlab-runner.nix
        # nur.nixosModules.nur
        inputs.hyprland.nixosModules.default
        {
          programs.hyprland.enable = true;
          # programs.hyprland.package = null;
        }
        (import ./overlays (inputs // {inherit system;}))
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
        rainbow = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/rainbow.nix ] ++ common_modules;
        };
        pixie = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/pixie.nix ] ++ common_modules ++ [{
            packages.media-packages.enable = lib.mkOverride 0 false;
            programs.steam.enable = lib.mkOverride 0 false;
            services.flatpak.enable = lib.mkOverride 0 false;
          }];
        };
      };
    };
}
