{ pkgs, lib, ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        "main" = {
          # Some programs don't respect colemaks capslock bind, so we force it here
          "capslock" = "backspace";
        };
      };
    };
  };
}
