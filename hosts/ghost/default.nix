{ config, pkgs, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
    inputs.agenix.nixosModules.default
    ../../system/nix.nix
    ./hardware-config.nix
    ./mastodon.nix
    ./nextcloud.nix
    ./nginx.nix
    ./syncthing.nix
    ./users.nix
    ./writefreely.nix
  ];

  # Use more aggressive compression then the default.
  virtualisation.digitalOceanImage.compressionMethod = "bzip2";
  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.utf8";

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;

  age = {
    identityPaths = [ "/root/.ssh/id_rsa" ];
  };

  system.stateVersion = "23.05"; # Never change this
}

