let
  keys = {
    colemak = {
      layout = "colemak";
      hints = "arstwfuyneio";
      left = "n";
      down = "e";
      up = "i";
      right = "o";
      next = "l";
      tabL = "u";
      tabR = "Y";
      insertMode = "s";
      insertQuit = "kk";
      menu = "s";
    };
  };
  accents = {
    red = {
      color = "#F44336";
      fg = "#ffffff";
    };
  };
  themes = {
    dark = {
      background = "~/.local/share/backgrounds/assembly_dark.png";
      opacity = 98;
      opacityHex = "ee";
      color = {
        type = "dark";
        bg = "#202020";
        bg_light = "#404040";
        bg_dark = "#191919";
        txt = "#FFFFFF";
        nontxt = "#252525";
        random_range = "[a-f]";
        normal = {
          black = "#404040";
          red = "#AB4642";
          green = "#A1B56C";
          yellow = "#E6C547";
          blue = "#6C99DA";
          magenta = "#C397D8";
          cyan = "#70C0BA";
          white = "#EAEAEA";
          #non standard
          orange = "#FF7500";
          brown = "#A07040";
        };
      };
    };
  };
in rec {
  key = keys.colemak;

  theme = themes.dark;
  color = theme.color;
  accent = accents.red;

  font = {
    mono = "Hack Nerd Font";
    interface = "Liberation Sans";
    size = {
      small = 12;
      medium = 14;
      big = 16;
    };
  };
}
