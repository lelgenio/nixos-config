{ pkgs, inputs, ... }: {
  # It's important to let Digital Ocean set the hostname so we get rDNS to work
  networking.hostName = "";

  imports = [
    inputs.nixos-mailserver.nixosModules.mailserver
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.lelgenio.xyz";
    domains = [ "lelgenio.xyz" ];
    certificateScheme = "acme-nginx";
    loginAccounts = {
      "lelgenio@lelgenio.xyz" = {
        hashedPassword = "$2y$05$z5s7QCXcs5uTFsfyYpwNJeWzb3RmzgWxNgcPCr0zjSytkLFF/qZmS";
        aliases = [ "postmaster@lelgenio.xyz" ];
      };
    };
  };

  # Webmail
  services.roundcube = rec {
    enable = true;
    package = pkgs.roundcube.withPlugins (p: [ p.carddav ]);
    hostName = "mail.lelgenio.xyz";
    extraConfig = ''
      $config['smtp_host'] = "tls://${hostName}:587";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
      $config['plugins'] = [ "carddav" ];
    '';
  };

}
