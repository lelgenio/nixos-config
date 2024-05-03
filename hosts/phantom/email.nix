{ pkgs, inputs, config, ... }: {
  # It's important to let Digital Ocean set the hostname so we get rDNS to work
  networking.hostName = "";

  imports = [
    inputs.nixos-mailserver.nixosModules.mailserver
  ];

  mailserver = {
    enable = true;
    fqdn = "lelgenio.xyz";
    domains = [
      "lelgenio.xyz"
      "git.lelgenio.xyz"
    ];
    certificateScheme = "acme-nginx";
    # Create passwords with
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "lelgenio@lelgenio.xyz" = {
        hashedPassword = "$2y$05$z5s7QCXcs5uTFsfyYpwNJeWzb3RmzgWxNgcPCr0zjSytkLFF/qZmS";
        aliases = [ "postmaster@lelgenio.xyz" ];
      };
      "noreply@git.lelgenio.xyz" = {
        hashedPassword = "$2b$05$TmR1R7ZwXfec7yrOfeBL7u3ZtyXf0up5dEO6uMWSvb/O7LPEm.j0.";
      };
    };
  };

  # Prefer ipv4 and use main ipv6 to avoid reverse DNS issues
  services.postfix.extraConfig = ''
    smtp_address_preference = ipv4
  '';

  # Webmail
  services.roundcube = {
    enable = true;
    package = pkgs.roundcube.withPlugins (p: [ p.carddav ]);
    hostName = "mail.lelgenio.xyz";
    extraConfig = ''
      $config['smtp_host'] = "tls://${config.mailserver.fqdn}:587";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
      $config['plugins'] = [ "carddav", "archive" ];
    '';
  };

}
