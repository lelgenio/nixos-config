{
  inputs,
  pkgs,
  config,
  ...
}:
{
  # Replace with unstable, since 24.05 does not have sig-helper
  disabledModules = [ "services/web-apps/invidious.nix" ];
  imports = [ (inputs.nixpkgs-unstable + "/nixos/modules/services/web-apps/invidious.nix") ];

  services.invidious = {
    enable = true;
    domain = "invidious.lelgenio.com";
    nginx.enable = true;
    port = 10601;
    http3-ytproxy.enable = true;
    sig-helper = {
      enable = true;
      package = pkgs.unstable.inv-sig-helper;
    };
    # {
    #     "visitor_data": "...",
    #     "po_token": "..."
    # }
    extraSettingsFile = config.age.secrets.phantom-invidious-settings.path;
    settings = {
      force_resolve = "ipv6";
      db = {
        user = "invidious";
        dbname = "invidious";
      };
    };
  };

  age.secrets.phantom-invidious-settings = {
    file = ../../secrets/phantom-invidious-settings.age;
    mode = "666";
  };
}
