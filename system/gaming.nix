{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.my.gaming.enable = lib.mkEnableOption { };

  config = lib.mkIf config.my.gaming.enable {
    programs.steam.enable = true;
    programs.steam.extraPackages =
      config.fonts.packages
      ++ (with pkgs; [
        capitaine-cursors
        bibata-cursors
        mangohud
        xdg-user-dirs
        gamescope

        # gamescope compatibility??
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ]);

    environment.systemPackages = with pkgs; [
      protontricks
      bottles
      inputs.dzgui-nix.packages.${pkgs.system}.default
    ];

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };

        # Warning: GPU optimisations have the potential to damage hardware
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
