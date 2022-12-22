{ pkgs, ... }: {
  services.cachix-watch-store = {
    enable = true;
    cacheName = "lelgenio";
    cachixTokenFile = "/etc/cachix-token";
  };
  systemd.services.cachix-watch-store-agent.serviceConfig.TimeoutStopSec = 3;
}
