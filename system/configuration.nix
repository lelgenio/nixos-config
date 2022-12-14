# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }: {
  imports = [ ./gamemode.nix ./cachix.nix ./media-packages.nix ./boot.nix ];
  packages.media-packages.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576; # Needed by DayZ
  };

  programs.adb.enable = true;
  services.udev.packages = [ pkgs.android-udev-rules ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
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
  programs.firejail.enable = true;

  security.rtkit.enable = true;
  services.openssh = {
    enable = true;
    kbdInteractiveAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    ports = [ 9022 ];
  };

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
    package = pkgs.bluezFull;
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
  users.users.lelgenio = {
    isNormalUser = true;
    description = "Leonardo Eugênio";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "bluetooth" ];
    shell = pkgs.fish;
  };
  # services.getty.autologinUser = "lelgenio";
  programs.fish.enable = true;
  # TODO: enable thunar plugins
  # programs.thunar.enable = true;
  # programs.thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pinentry-curses
    pavucontrol

    glib # gsettings
    usbutils
    # dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
  ];

  services.geoclue2.enable = true;
  # programs.qt5ct.enable = true;
  programs.steam.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  security.sudo.wheelNeedsPassword = false;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
        "https://lelgenio.cachix.org"
        "https://wegank.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lelgenio.cachix.org-1:W8tMlmDFLU/V+6DlChXjekxoHZpjgVHZpmusC4cueBc="
        "wegank.cachix.org-1:xHignps7GtkPP/gYK5LvA/6UFyz98+sgaxBSy7qK0Vs="
      ];
    };
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
