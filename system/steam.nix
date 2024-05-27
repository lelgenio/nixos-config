{ config, pkgs, inputs, ... }: {
  programs.steam.enable = true;
  programs.steam.package = pkgs.steam.override {
    extraLibraries = pkgs: with config.hardware.opengl;
      if pkgs.hostPlatform.is64bit
      then [ package ] ++ extraPackages
      else [ package32 ] ++ extraPackages32;

    extraPkgs = pkgs: with pkgs; [
      capitaine-cursors
      bibata-cursors
      mangohud
      xdg-user-dirs
    ];
  };
  environment.systemPackages = with pkgs; [
    protontricks
    bottles
  ];

  programs.dzgui.enable = true;
  programs.dzgui.package = inputs.dzgui-nix.packages.${pkgs.system}.default;
}
