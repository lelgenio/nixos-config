{ pkgs, ... }:
{
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        DiscoverableTimeout = 0;
        # Discoverable = true;
        AlwaysPairable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
