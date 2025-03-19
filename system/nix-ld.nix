{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.my.nix-ld.enable = lib.mkEnableOption { };

  config = lib.mkIf (config.my.nix-ld.enable) {
    programs.nix-ld = {
      enable = true;
      libraries =
        with pkgs;
        # run appimages + linux games natively
        [ fuse ]
        ++ (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
        ++ (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs);
    };
  };
}
