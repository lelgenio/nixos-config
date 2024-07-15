{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _thunar-terminal
    (xfce.thunar.override {
      thunarPlugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
      ];
    })
  ];

  wayland.windowManager.sway = {
    extraConfig = ''
      exec_always systemctl --user import-environment PATH
    '';
  };

  xdg.configFile = {
    "Thunar/".source = ./thunar;
  };
}
