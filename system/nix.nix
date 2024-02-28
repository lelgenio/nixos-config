{ lib, config, pkgs, inputs, ... }:
let
  collectFlakeInputs = input:
    [ input ] ++ lib.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));
in
{
  system.extraDependencies = collectFlakeInputs inputs.self;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        # "http://nixcache.lelgenio.1337.cx:5000"
        "https://hyprland.cachix.org"
        "https://lelgenio.cachix.org"
        "https://wegank.cachix.org"
        "https://snowflakeos.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "nixcache.lelgenio.1337.cx:zxCfx7S658llDgAUG0JVyNrlAdFVvPniSdDOkvfTPS8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lelgenio.cachix.org-1:W8tMlmDFLU/V+6DlChXjekxoHZpjgVHZpmusC4cueBc="
        "wegank.cachix.org-1:xHignps7GtkPP/gYK5LvA/6UFyz98+sgaxBSy7qK0Vs="
        "snowflakeos.cachix.org-1:gXb32BL86r9bw1kBiw9AJuIkqN49xBvPd1ZW8YlqO70="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };
}
