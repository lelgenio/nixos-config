{ config, pkgs, inputs, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
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
      ];
      trusted-public-keys = [
        # "nixcache.lelgenio.1337.cx:zxCfx7S658llDgAUG0JVyNrlAdFVvPniSdDOkvfTPS8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lelgenio.cachix.org-1:W8tMlmDFLU/V+6DlChXjekxoHZpjgVHZpmusC4cueBc="
        "wegank.cachix.org-1:xHignps7GtkPP/gYK5LvA/6UFyz98+sgaxBSy7qK0Vs="
      ];
    };
    package = pkgs.unstable.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
