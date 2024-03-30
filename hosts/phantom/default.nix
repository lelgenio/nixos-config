{ config, pkgs, inputs, ... }: {
  imports = [
    ./vpsadminos.nix
    inputs.agenix.nixosModules.default
    ../../system/nix.nix
    ./hardware-config.nix
    ./mastodon.nix
    ./nextcloud.nix
    ./nginx.nix
    ./syncthing.nix
    ./users.nix
    ./writefreely.nix
    ./renawiki.nix
    ./email.nix
  ];

  # # Enable networking
  # networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.utf8";

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;

  age = {
    identityPaths = [ "/root/.ssh/id_rsa" ];
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:40";
    operation = "switch";
    flags = [ "--update-input" "nixpkgs" "--no-write-lock-file" "-L" ];
    flake = "github:lelgenio/nixos-config#phantom";
  };

  system.stateVersion = "23.05"; # Never change this
}

