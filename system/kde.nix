{ config, pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.autologin.user = "lelgenio";
  programs.dconf.enable = true;
  # environment.systemPackages = with pkgs;
  #   with gnome; [
  #     gnome-tweaks
  #     dconf-editor
  #   ];
}
