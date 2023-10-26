{ pkgs, lib, inputs, ... }: lib.mkIf (pkgs.uservars.desktop == "gnome") {

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
    "org/gnome/desktop/wm/preferences" = lib.mkForce {
      button-layout = "appmenu:close";
    };
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
    lollypop
    pitivi
    gnome-passwordsafe
  ];

}
