# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./gamemode.nix
    ./cachix.nix
    ./media-packages.nix
    ./boot.nix
    ./thunar.nix
    ./nix.nix
    ./fonts.nix
    ./sound.nix
    ./bluetooth.nix
    ./mouse.nix
    ./locale.nix
    ./users.nix
    ./containers.nix
    ./network.nix
    ../settings
  ];

  my = import ../user/variables.nix;

  zramSwap.enable = true;

  programs.adb.enable = true;
  services.udev.packages = [ pkgs.android-udev-rules ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  packages.media-packages.enable = true;
  environment.systemPackages = with pkgs; [
    pavucontrol

    glib # gsettings
    usbutils
    # dracula-theme # gtk theme
    adwaita-icon-theme # default gnome cursors

    nix-output-monitor
  ];

  services.geoclue2.enable = true;

  # Workaround for nm-wait-online hanging??
  # Ref: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online = {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.networkmanager}/bin/nm-online -q"
    ];
  };

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
