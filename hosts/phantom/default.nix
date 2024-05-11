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
    ./email.nix
    ./forgejo.nix
  ];

  services.nginx.virtualHosts."lelgenio.xyz" = {
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

  system.autoUpgrade = {
    enable = true;
    dates = "04:40";
    operation = "switch";
    flags = [ "--update-input" "nixpkgs" "--no-write-lock-file" "-L" ];
    flake = "git+https://git.lelgenio.xyz/lelgenio/nixos-config#phantom";
  };

  system.stateVersion = "23.05"; # Never change this
}

