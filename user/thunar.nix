{ pkgs, ... }: {
  home.packages = with pkgs; [
    _thunar-terminal
    (xfce.thunar.override {
      thunarPlugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin ];
    })
  ];

  xdg.configFile = {
    "Thunar/".source = ./thunar;
  };
}
