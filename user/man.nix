{ config, pkgs, lib, inputs, ... }:
let inherit (pkgs.uservars) key theme color accent font desktop;
in {
  config = {
    programs.man = {
      enable = true;
      generateCaches = true;
    };
    home.sessionVariables = {
      PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      MANPAGER = "${pkgs.kak-man-pager}/bin/kak-man-pager";
      SYSTEMD_PAGER = "${pkgs.kak-pager}/bin/kak-pager";
      SYSTEMD_PAGERSECURE = "1";
    };
  };
}
