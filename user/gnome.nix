{ pkgs, lib, ... }: lib.mkIf (pkgs.uservars.desktop == "gnome") {

  dconf.settings = with pkgs; with uservars.theme; {
    "org/gnome/desktop/interface" = {
      gtk-theme = gtk_theme;
      icon-theme = icon_theme;
      cursor-theme = cursor_theme;
      color-scheme = "prefer-${color.type}";
    };
    "org/gnome/desktop/wm/preferences" = lib.mkForce {
      button-layout = "menu:close";
    };
  };

}
