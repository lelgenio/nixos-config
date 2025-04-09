{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (config.my) theme font desktop;
  inherit (theme)
    color
    gtk_theme
    icon_theme
    cursor_theme
    ;
in
lib.mkIf (desktop == "sway") {
  home.pointerCursor = {
    name = cursor_theme;
    size = 24;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
  };
  gtk =
    {
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
    }
    // (
      let
        shared.extraConfig = {
          gtk-decoration-layout = "menu:";
        };
      in
      {
        gtk4 = shared;
        gtk3 = shared;
      }
    );

  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = gtk_theme;
      icon-theme = icon_theme;
      cursor-theme = cursor_theme;
      color-scheme = "prefer-${color.type}";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "menu:";
    };
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

  home.packages = with pkgs; [
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
