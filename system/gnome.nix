# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Workaround for https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.displayManager.autoLogin = {
    enable = true;
    user = "lelgenio";
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # services.xserver.displayManager.autologin.user = "lelgenio";
  environment.systemPackages =
    with pkgs;
    with gnome;
    [
      gnome-tweaks
      dconf-editor

      chrome-gnome-shell
      gnomeExtensions.quick-settings-audio-devices-hider
    ];
}
