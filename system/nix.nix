{ config, pkgs, inputs, ... }: {
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      substituters = [
        # "http://nixcache.lelgenio.1337.cx:5000"
        "https://hyprland.cachix.org"
        "https://lelgenio.cachix.org"
        "https://wegank.cachix.org"
        "https://snowflakeos.cachix.org/"
      ];
      trusted-public-keys = [
        # "nixcache.lelgenio.1337.cx:zxCfx7S658llDgAUG0JVyNrlAdFVvPniSdDOkvfTPS8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lelgenio.cachix.org-1:W8tMlmDFLU/V+6DlChXjekxoHZpjgVHZpmusC4cueBc="
        "wegank.cachix.org-1:xHignps7GtkPP/gYK5LvA/6UFyz98+sgaxBSy7qK0Vs="
        "snowflakeos.cachix.org-1:gXb32BL86r9bw1kBiw9AJuIkqN49xBvPd1ZW8YlqO70="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
