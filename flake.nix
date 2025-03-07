{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vpsadminos.url = "github:vpsfreecz/vpsadminos";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dzgui-nix.url = "github:lelgenio/dzgui-nix";

    tlauncher = {
      url = "git+https://git.lelgenio.xyz/lelgenio/tlauncher-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";

    # my stuff
    dhist.url = "github:lelgenio/dhist";
    demoji.url = "github:lelgenio/demoji";
    wl-crosshair.url = "github:lelgenio/wl-crosshair";
    warthunder-leak-counter.url = "git+https://git.lelgenio.com/lelgenio/warthunder-leak-counter";
    made-you-look.url = "git+https://git.lelgenio.com/lelgenio/made-you-look";
    catboy-spinner = {
      url = "git+https://git.lelgenio.com/lelgenio/catboy-spinner";
      flake = false;
    };
    tomater = {
      url = "git+https://git.lelgenio.com/lelgenio/tomater";
      flake = false;
    };
    youre-wrong = {
      url = "git+https://git.lelgenio.com/lelgenio/youre-wrong";
      flake = false;
    };
    hello-fonts = {
      url = "git+https://git.lelgenio.com/lelgenio/hello-fonts";
      flake = false;
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
          ./system/sops.nix
          ./system/greetd.nix
          { login-manager.greetd.enable = desktop == "sway"; }

          inputs.agenix.nixosModules.default
          inputs.sops-nix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko
          (
            { config, ... }:
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lelgenio = {
                my = config.my;
                imports = [
                  ./user/home.nix
                ];
              };
              home-manager.backupFileExtension = "bkp";
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          )
        ]
        ++ lib.optional (desktop == "gnome") ./system/gnome.nix
        ++ lib.optional (desktop == "kde") ./system/kde.nix;
    in
    {
      checks."${system}" = {
        disko-format-i15 = pkgs.callPackage ./hosts/i15/partitions-test.nix { };
      };
      nixosConfigurations = {
        i15 = lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/i15 ] ++ common_modules;
        };
        monolith = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/monolith
            ./system/monolith-gitlab-runner.nix
            ./system/monolith-bitbucket-runner.nix
            ./system/monolith-forgejo-runner.nix
            ./system/nix-serve.nix
          ] ++ common_modules;
        };
        double-rainbow = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/double-rainbow.nix
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
                services.flatpak.enable = lib.mkOverride 0 false;
              }
            ];
        };
        phantom = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./hosts/phantom
          ];
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

      # formatter.${system} = pkgs.nixfmt-rfc-style;
      formatter.${system} = (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper;
    };
}
