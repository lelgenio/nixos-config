{ config, pkgs, lib, inputs, ... }:
let inherit (import ./variables.nix) key theme color accent font;
in {
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
