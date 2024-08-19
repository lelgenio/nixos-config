{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
lib.mkIf (config.my.desktop == "gnome") {

  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.gnome.adwaita-icon-theme;
    gtk.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # gtk-theme = "Adwaita";
      # icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
      # color-scheme = "default";
    };
    "org/gnome/desktop/wm/preferences" = lib.mkForce { button-layout = "appmenu:close"; };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "lv3:lsgt_switch" ];
    };
  };

  home.packages = with pkgs; [
    adw-gtk3

    newsflash
    foliate
    amberol
    pitivi
    keepassxc

    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
  ];

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  xdg.defaultApplications = {
    enable = lib.mkForce false;
  };
}
