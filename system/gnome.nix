{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome = {
      enable = true;
      # Enable VRR (Variable Refresh Rate)
      extraGSettingsOverridePackages = with pkgs; [ gnome.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      '';
    };
    displayManager.gdm.enable = true;
  };

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

  hardware.opentabletdriver.enable = lib.mkForce false;

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
