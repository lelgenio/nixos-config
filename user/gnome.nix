{
  pkgs,
  lib,
  inputs,
  ...
}:
lib.mkIf (pkgs.uservars.desktop == "gnome") {

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
    inputs.nixos-conf-editor.packages.${pkgs.system}.nixos-conf-editor
    inputs.nix-software-center.packages.${pkgs.system}.nix-software-center

    adw-gtk3

    newsflash
    foliate
    amberol
    pitivi
    gnome-passwordsafe

    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  xdg.defaultApplications = {
    enable = true;
    text-editor = "codium.desktop";
    image-viewer = "org.gnome.eog.desktop";
    video-player = "org.gnome.Totem.desktop";
    web-browser = "firefox.desktop";
    document-viewer = "org.gnome.Evince.desktop";
    file-manager = "org.gnome.Nautilus.desktop";
    archive-manager = "org.gnome.FileRoller.desktop;";
    email-client = "thunderbird.desktop";
    torrent-client = "torrent.desktop";
  };
}
