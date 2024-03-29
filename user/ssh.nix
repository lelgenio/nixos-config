{ config, pkgs, lib, ... }:
let inherit (pkgs.uservars) username mail;
in {
  config = {
    programs.ssh.enable = true;
    programs.ssh.matchBlocks = {
      monolith = {
        user = "lelgenio";
        hostname = "lelgenio.1337.cx";
        port = 9022;
      };
      ghost = {
        user = "root";
        hostname = "ghost.lelgenio.xyz";
        port = 9022;
      };
      phantom = {
        user = "root";
        hostname = "phantom.lelgenio.xyz";
        port = 9022;
      };
    };
  };
}
