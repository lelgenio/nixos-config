{ pkgs, ... }: {
  services.cachix-watch-store = {
    enable = true;
    cacheName = "lelgenio";
    cachixTokenFile = "/etc/cachix-token";
  };
}
