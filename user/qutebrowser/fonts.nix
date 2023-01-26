{ pkgs, ... }:
let
  inherit (pkgs.uservars) font;
in
{
  programs.qutebrowser.settings.fonts =
    let
      mkFont = name: size: "${toString size}px ${name}";
      DEF_MONO = mkFont font.mono font.size.medium;
      BIG_MONO = mkFont font.mono font.size.big;
      DEF_INTER = mkFont font.interface font.size.medium;
      BIG_INTER = mkFont font.interface font.size.big;
    in
    {
      debug_console = BIG_INTER;
      downloads = BIG_INTER;
      hints = "bold " + BIG_MONO;
      keyhint = BIG_INTER;
      prompts = BIG_INTER;
      statusbar = DEF_MONO;
      completion = {
        entry = BIG_INTER;
        category = BIG_INTER;
      };
      messages = {
        error = BIG_INTER;
        info = BIG_INTER;
        warning = BIG_INTER;
      };
      tabs = {
        selected = DEF_INTER;
        unselected = DEF_INTER;
      };
    };
}

