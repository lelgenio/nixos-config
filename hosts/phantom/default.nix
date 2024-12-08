{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.vpsadminos.nixosConfigurations.container
    inputs.agenix.nixosModules.default
    ../../system/nix.nix
    ./hardware-config.nix
    ./mastodon.nix
    ./lemmy.nix
    ./nextcloud.nix
    ./nginx.nix
    ./syncthing.nix
    ./users.nix
    ./writefreely.nix
    ./email.nix
    ./forgejo.nix
    ./invidious.nix
    ./davi.nix
    ./goofs.nix
  ];

  networking.hostName = "phantom";

  services.nginx.virtualHosts."lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    root = pkgs.runCommand "www-dir" { } ''
      mkdir -p $out
      cat > $out/index.html <<EOF
        <!DOCTYPE html>
        <html lang="en">
        <body>
          <h1>
              Nothing to see here!
          <h1>
        </body>
        </html>
      EOF
    '';
  };

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

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # needed by bitbucket runner ???
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  nix.settings = {
    cores = 1;
    max-jobs = 1;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:40";
    operation = "switch";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "--print-build-logs"
    ];
    flake = "git+https://git.lelgenio.com/lelgenio/nixos-config#phantom";
  };

  networking.firewall.allowedTCPPorts = [ 8745 ];

  system.stateVersion = "23.05"; # Never change this
}
