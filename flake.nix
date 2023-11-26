{
  description = "My system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ranger-icons.url = "github:alexanderjeurissen/ranger_devicons";
    ranger-icons.flake = false;

    material-wifi-icons.url = "github:dcousens/material-wifi-icons";
    material-wifi-icons.flake = false;

    plymouth-themes.url = "github:adi1090x/plymouth-themes";
    plymouth-themes.flake = false;

    lipsum.url = "github:hannenz/lipsum";
    lipsum.flake = false;

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dzgui-nix = {
      url = "github:lelgenio/dzgui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tlauncher = {
      url = "github:lelgenio/tlauncher-nix";
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
    maildir-notify-daemon = {
      url = "github:lelgenio/maildir-notify-daemon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wl-crosshair = {
      url = "github:lelgenio/wl-crosshair";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-fixed-steam.url = "github:lelgenio/nixpkgs/test-steam-fix";

    # gnome stuff
    nixos-conf-editor.url = "github:vlinkz/nixos-conf-editor";
    nix-software-center.url = "github:vlinkz/nix-software-center";
  };
  outputs = inputs@{ nixpkgs, home-manager, nur, ... }:
    let
      inherit (import ./user/variables.nix) desktop;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = old_overlays.all;
      };
      lib = nixpkgs.lib;

      packages = import ./pkgs { inherit pkgs inputs; };

      old_overlays = (import ./overlays { inherit packages inputs; });

      specialArgs = { inherit inputs; };
      common_modules = [
        { nixpkgs.pkgs = pkgs; }
        ./system/configuration.nix
        ./system/secrets.nix
        ./system/specialisation.nix
        # nur.nixosModules.nur
        inputs.agenix.nixosModules.default
        inputs.hyprland.nixosModules.default
        inputs.dzgui-nix.nixosModules.default
        { programs.hyprland.enable = (desktop == "hyprland"); }
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
      ] ++ lib.optional (desktop == "sway") ./system/sway.nix
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
            ./system/nix-serve.nix
            ./system/steam.nix
            { services.vpn.enable = true; }
          ] ++ common_modules;
        };
        rainbow = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/rainbow.nix
            { services.vpn.enable = true; }
            ./system/rainbow-gitlab-runner.nix
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
          modules = [ ./hosts/pixie.nix ] ++ common_modules ++ [{
            packages.media-packages.enable = lib.mkOverride 0 false;
            programs.steam.enable = lib.mkOverride 0 false;
            services.flatpak.enable = lib.mkOverride 0 false;
          }];
        };
        ghost = lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/ghost ];
        };
      };

      homeConfigurations.lelgenio = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs;
          osConfig = { };
        };

        modules = [ ./user/home.nix ];
      };

      packages.${system} = pkgs // packages;

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
