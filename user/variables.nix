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
      tabL = "U";
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
      gtk_theme = "Orchis-Red-Dark-Compact";
      icon_theme = "Papirus-Dark";
      cursor_theme = "Bibata-Modern-Classic";

      background = ./backgrounds/nixos-dark-pattern.png;
      opacity = 95;
      opacityHex = "ee";
      color = {
        type = "dark";
        bg = "#191919";
        bg_light = "#404040";
        bg_dark = "#141414";
        txt = "#FFFFFF";
        nontxt = "#232323";
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
    light = {
      gtk_theme = "Orchis-Red-Light-Compact";
      icon_theme = "Papirus-Light";
      cursor_theme = "Bibata-Modern-Classic";

      background = ./backgrounds/nixos-light-pattern.png;
      opacity = 95;
      opacityHex = "ee";
      color = {
        type = "light";
        bg = "#FFFFFF";
        bg_light = "#A0A0A0";
        bg_dark = "#EEEEEE";
        txt = "#303030";
        nontxt = "#D0D0D0";
        random_range = "[0-4]";
        normal = {
          black = "#555555";
          red = "#D54E53";
          green = "#008800";
          yellow = "#B3A400";
          blue = "#0D68A8";
          magenta = "#C397D8";
          cyan = "#00A0A5";
          white = "#999999";
          #non standard
          orange = "#FF7500";
          brown = "#A07040";
        };
      };
    };
  };
in
rec {
  inherit themes;

  key = keys.colemak;

  theme = themes.dark;
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

  username = "lelgenio";
  mail = {
    personal = {
      from = "Leonardo Eugênio";
      user = "lelgenio@disroot.org";
      imap = "disroot.org";
      smtp = "disroot.org";
      pass = "disroot.org";
    };
    work = {
      from = "Leonardo Eugênio";
      user = "leonardo@wopus.com.br";
      imap = "imap.hostinger.com";
      smtp = "smtp.hostinger.com";
      pass = "Work/wopus_email";
    };
  };
  nextcloud = {
    name = "disroot";
    user = "lelgenio";
    host = "cloud.disroot.org";
    pass = "disroot.org";
  };

  dmenu = "bmenu";
  desktop = "sway";
  browser = "firefox";
  editor = "kakoune";
}
