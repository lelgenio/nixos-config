{ config, pkgs, lib, inputs, ... }: {
  home.pointerCursor = {
    name = "capitaine-cursors";
    size = 32;
    package = pkgs.capitaine-cursors;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    font = {
      name = pkgs.uservars.font.interface;
      size = pkgs.uservars.font.size.medium;
    };
    theme = {
      name = "Orchis-Red-Dark-Compact";
      package = pkgs.orchis_theme_compact;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus_red;
    };
  };
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  #   # style.package = pkgs.libsForQt5.qtstyleplugins;
  #   # style.name = "gtk2";
  # };
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum

    pkgs.capitaine-cursors
    pkgs.orchis_theme_compact
    pkgs.papirus_red

    ## fonts
    liberation_ttf
    hack-font
    font-awesome_5
    fira-code
    nerdfonts_fira_hack
    material-wifi-icons

  ];
}
