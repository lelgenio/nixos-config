{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ranger-icons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-icons.flake = false;

    plymouth-themes.url = "github:adi1090x/plymouth-themes";
    plymouth-themes.flake = false;

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-24_05.follows = "nixpkgs";
    };

    dzgui-nix = {
      url = "github:lelgenio/dzgui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tlauncher = {
      url = "git+https://git.lelgenio.xyz/lelgenio/tlauncher-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my stuff
    dhist = {
      url = "github:lelgenio/dhist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    demoji = {
      url = "github:lelgenio/demoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wl-crosshair = {
      url = "github:lelgenio/wl-crosshair";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # gnome stuff
    nixos-conf-editor = {
      url = "github:vlinkz/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center = {
      url = "github:vlinkz/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      nixpkgsConfig = {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = old_overlays.all;
      };

      inherit (import ./user/variables.nix) desktop;
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs nixpkgsConfig;
      lib = inputs.nixpkgs.lib;

      packages = import ./pkgs { inherit pkgs inputs; };

      old_overlays = (import ./overlays { inherit packages inputs; });

      specialArgs = {
        inherit inputs;
      };
      common_modules =
        [
          { nixpkgs.pkgs = pkgs; }
          ./system/configuration.nix
          ./system/secrets.nix
          ./system/specialisation.nix
          ./system/greetd.nix
          { login-manager.greetd.enable = desktop == "sway"; }

          inputs.agenix.nixosModules.default
          inputs.dzgui-nix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lelgenio = import ./user/home.nix;
            home-manager.backupFileExtension = "bkp";
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ]
        ++ lib.optional (desktop == "gnome") ./system/gnome.nix
        ++ lib.optional (desktop == "kde") ./system/kde.nix;
    in
    {
      nixosConfigurations = {
        i15 = lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/i15.nix ] ++ common_modules;
        };
        monolith = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/monolith.nix
            ./system/monolith-gitlab-runner.nix
            ./system/monolith-forgejo-runner.nix
            ./system/nix-serve.nix
            ./system/steam.nix
          ] ++ common_modules;
        };
        rainbow = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/rainbow.nix
            ./system/rainbow-gitlab-runner.nix
          ] ++ common_modules;
        };
        double-rainbow = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/double-rainbow.nix
            ./system/rainbow-gitlab-runner.nix
          ] ++ common_modules;
        };
        pixie = lib.nixosSystem {
          inherit system specialArgs;
          modules =
            [ ./hosts/pixie.nix ]
            ++ common_modules
            ++ [
              {
                packages.media-packages.enable = lib.mkOverride 0 false;
                programs.steam.enable = lib.mkOverride 0 false;
                services.flatpak.enable = lib.mkOverride 0 false;
              }
            ];
        };
        phantom = lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/phantom ];
        };
      };

      homeConfigurations.lelgenio = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs;
          osConfig = { };
        };

        modules = [ ./user/home.nix ];
      };

      packages.${system} = pkgs // packages;

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
