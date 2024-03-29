# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }: {
  imports = [
    ./gamemode.nix
    ./cachix.nix
    ./media-packages.nix
    ./boot.nix
    ./thunar.nix
    ./nix.nix
  ];

  zramSwap.enable = true;

  programs.adb.enable = true;
  services.udev.packages = [ pkgs.android-udev-rules ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  # Open kde connect ports
  programs.kdeconnect.enable = true;
  networking.firewall.allowedTCPPorts = [ 55201 ];

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  environment.variables.TZ = config.time.timeZone;
  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.utf8";

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.autologin.user = "lelgenio";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "colemak";
  };
  console.keyMap = "colemak";
  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.flatpak.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "monthly";
  virtualisation.docker.autoPrune.flags = [ "--all --volumes" ];

  programs.extra-container.enable = true;

  programs.firejail.enable = true;

  security.rtkit.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 9022 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  # programs.ssh = {
  #   startAgent = true;
  #   extraConfig = ''
  #     AddKeysToAgent yes
  #   '';
  # };

  ## Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        DiscoverableTimeout = 0;
        # Discoverable = true;
        AlwaysPairable = true;
      };
      Policy = { AutoEnable = true; };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

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
  users.users.root.initialHashedPassword = "$y$j9T$E3aBBSSq0Gma8hZD9L7ov0$iCGDW4fqrXWfHO0qodBYYgMFA9CpIraoklHcPbJJrM3";

  # services.getty.autologinUser = "lelgenio";
  programs.fish.enable = true;

  programs.dzgui.enable = true;
  programs.dzgui.package = inputs.dzgui-nix.packages.${pkgs.system}.default;

  packages.media-packages.enable = true;
  environment.systemPackages = with pkgs; [
    pavucontrol

    glib # gsettings
    usbutils
    # dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
  ];

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts_fira_hack
  ];

  services.geoclue2.enable = true;
  # programs.qt5ct.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
