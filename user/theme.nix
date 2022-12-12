{ config, pkgs, lib, inputs, ... }:
with pkgs.uservars; {
  home.pointerCursor = {
    name = cursor_theme;
    size = 24;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    font = {
      name = font.interface;
      size = font.size.small;
    };
    theme = {
      name = gtk_theme;
      package = pkgs.orchis_theme_compact;
    };
    iconTheme = {
      name = icon_theme;
      package = pkgs.papirus_red;
    };
  };
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  #   # style.package = pkgs.libsForQt5.qtstyleplugins;
  #   # style.name = "gtk2";
  # };

  # fonts.fontconfig.enable = true;
  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      # color_scheme_path=/nix/store/f07mk0vrm47jxw3y5v99hxncy0w4vcyq-qt5ct-1.5/share/qt5ct/colors/darker.conf
      custom_palette=false
      icon_theme=${icon_theme}
      standard_dialogs=default
      style=kvantum-dark

      # [Fonts]
      # fixed=@Variant(\0\0\0@\0\0\0\x1c\0H\0\x61\0\x63\0k\0 \0N\0\x65\0r\0\x64\0 \0\x46\0o\0n\0t@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
      # general=@Variant(\0\0\0@\0\0\0\x1e\0L\0i\0\x62\0\x65\0r\0\x61\0t\0i\0o\0n\0 \0S\0\x61\0n\0s@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    '';
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Gtk/FontName" = "${font.interface} ${toString font.size.small}";
      "Net/ThemeName" = "${gtk_theme}";
      "Net/IconThemeName" = "${icon_theme}";
      "Gtk/CursorThemeName" = "${cursor_theme}";
      "Gtk/CursorThemeSize" = 24;
      "Net/SoundThemeName" = "freedesktop";
    };
  };

  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "gtk3"; };
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum

    pkgs.bibata-cursors
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
