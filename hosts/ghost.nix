{ config, pkgs, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
    inputs.agenix.nixosModules.default
    ../system/nix.nix
  ];

  # Use more aggressive compression then the default.
  virtualisation.digitalOceanImage.compressionMethod = "bzip2";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.utf8";

  security.rtkit.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 9022 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.lelgenio = {
    isNormalUser = true;
    description = "Leonardo Eugênio";
    hashedPassword = "$y$j9T$0e/rczjOVCy7PuwC3pG0V/$gTHZhfO4wQSlFvbDyfghbCnGI2uDI0a52zSrQ/yOA5A";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "bluetooth" "corectrl" "vboxusers" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxR/w+38b2lX90yNBqhq3mUmkn1WGu6GAPhN1tVp2ZjYRJNV/+5gWCnTtOWYtDx35HmK/spQ2Qy8X9ttkzORa24fysNx1Iqn/TiXhD7eIJjbGPnrOpIKTkW5/uB3SD/P5NBSa06//BaqJU4sBlG79hoXRpod052hQtdpTVDiMCIV+iboWPKqopmJJfWdBtVnHXs9rep0htPRExxGslImFk7Z6xjcaHyCpIQZPlOGf+sGsmUU7jRqzvZFV8ucIdbnAlMHrU4pepNFhuraESyZVTa/bi9sw0iozXp5Q5+5thMebEslmT1Z771kI4sieDy+O4r8c0Sx2/VY1UAzcpq1faggc3YB01MTh+tiEC6xdMvZLrQGL1NBWjHleMyL53GU5ERluC0vXJF3Hv3BGGBDfXWbrEm5n06DHr2apRVJGC0LwiQ7Woud1X4V4X1pKSusxCVMjT2lmcOwV6YhKhB2sowJc1OdMx4+tL0UWE+YKSZgBHfolwk6ml0F4EO9nnUHc= lelgenio@i15"
    ];
  };
  users.users.root = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxR/w+38b2lX90yNBqhq3mUmkn1WGu6GAPhN1tVp2ZjYRJNV/+5gWCnTtOWYtDx35HmK/spQ2Qy8X9ttkzORa24fysNx1Iqn/TiXhD7eIJjbGPnrOpIKTkW5/uB3SD/P5NBSa06//BaqJU4sBlG79hoXRpod052hQtdpTVDiMCIV+iboWPKqopmJJfWdBtVnHXs9rep0htPRExxGslImFk7Z6xjcaHyCpIQZPlOGf+sGsmUU7jRqzvZFV8ucIdbnAlMHrU4pepNFhuraESyZVTa/bi9sw0iozXp5Q5+5thMebEslmT1Z771kI4sieDy+O4r8c0Sx2/VY1UAzcpq1faggc3YB01MTh+tiEC6xdMvZLrQGL1NBWjHleMyL53GU5ERluC0vXJF3Hv3BGGBDfXWbrEm5n06DHr2apRVJGC0LwiQ7Woud1X4V4X1pKSusxCVMjT2lmcOwV6YhKhB2sowJc1OdMx4+tL0UWE+YKSZgBHfolwk6ml0F4EO9nnUHc= lelgenio@i15"
    ];
    initialHashedPassword = "$y$j9T$E3aBBSSq0Gma8hZD9L7ov0$iCGDW4fqrXWfHO0qodBYYgMFA9CpIraoklHcPbJJrM3";
  };
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "cloud.lelgenio.xyz";
    https = true;
    config = {
      adminpassFile = config.age.secrets.ghost-nextcloud.path;
    };
  };

  services.mastodon = {
    enable = true;
    localDomain = "social.lelgenio.xyz";
    configureNginx = true;
    smtp.fromAddress = "lelgenio@disroot.org";
    extraConfig.SINGLE_USER_MODE = "true";
  };

  services.writefreely = {
    enable = true;
    acme.enable = true;
    nginx.enable = true;
    nginx.forceSSL = true;
    host = "blog.lelgenio.xyz";
    admin.name = "lelgenio";
    admin.initialPasswordFile = config.age.secrets.ghost-writefreely.path;
    settings.app = {
      site_name = "Leo's blog";
      single_user = true;
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "lelgenio@disroot.org";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 2); # 2 GB
  }];

  age = {
    identityPaths = [ "/root/.ssh/id_rsa" ];
    secrets.ghost-nextcloud = {
      file = ../secrets/ghost-nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
    secrets.ghost-writefreely = {
      file = ../secrets/ghost-writefreely.age;
      mode = "400";
      owner = "writefreely";
      group = "writefreely";
    };
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/b19e7272-8fd1-4999-93eb-abc6d5c0a1cc";
    fsType = "btrfs";
    options = [ "subvol=@var" ];
  };

  system.stateVersion = "23.05"; # Never change this
}

