{ config, pkgs, lib, inputs, ... }:
let inherit (pkgs.uservars) key theme color accent font;
in {
  services.syncthing = {
    enable = true;
    # tray.enable = true;
  };
}
