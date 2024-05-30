{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.cachix-watch-store = {
    enable = true;
    cacheName = "lelgenio";
    cachixTokenFile = config.age.secrets.lelgenio-cachix.path;
  };
  systemd.services.cachix-watch-store-agent = {
    serviceConfig.TimeoutStopSec = 3;
    # If we don't do this, cachix tends to timeout
    serviceConfig.KillMode = lib.mkForce "control-group";
  };
}
