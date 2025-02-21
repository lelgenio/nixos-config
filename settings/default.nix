{ lib, ... }:
{
  options = {
    my = {
      themes = lib.mkOption { };
      key = lib.mkOption { };
      theme = lib.mkOption { };
      accent = lib.mkOption { };
      font = lib.mkOption { };
      username = lib.mkOption { type = lib.types.str; };
      mail = lib.mkOption { };
      dmenu = lib.mkOption { type = lib.types.str; };
      desktop = lib.mkOption { type = lib.types.str; };
      browser = lib.mkOption { type = lib.types.str; };
      editor = lib.mkOption { type = lib.types.str; };
    };
  };
}
