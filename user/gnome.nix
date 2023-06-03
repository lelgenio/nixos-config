{ pkgs, lib, inputs, ... }: lib.mkIf (pkgs.uservars.desktop == "gnome") {

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # gtk-theme = "Adwaita";
      # icon-theme = "Adwaita";
      # cursor-theme = "Adwaita";
      # color-scheme = "default";
    };
    "org/gnome/desktop/wm/preferences" = lib.mkForce {
      button-layout = "appmenu:close";
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
  ];

}
