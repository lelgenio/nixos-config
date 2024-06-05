{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my) username mail;
in
{
  config = {
    programs.ssh.enable = true;
    programs.ssh.matchBlocks = {
      monolith = {
        user = "lelgenio";
        hostname = "monolith.lelgenio.com";
        port = 9022;
      };
      phantom = {
        user = "root";
        hostname = "phantom.lelgenio.com";
        port = 9022;
      };
    };
  };
}
