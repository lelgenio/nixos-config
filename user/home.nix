{ config, pkgs, lib, ... }:
let
  inherit (import ./variables.nix) key theme color accent font;

  papirus_red = (pkgs.unstable.papirus-icon-theme.override { color = "red"; });
  orchis_theme_compact =
    (pkgs.orchis-theme.override { tweaks = [ "compact" "solid" ]; });
  nerdfonts_fira_hack =
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
  volumesh =
    pkgs.writeShellScriptBin "volumesh" (builtins.readFile ./scripts/volumesh);
in {
  imports = [
    ./waybar.nix
    ./helix.nix
    ./kakoune.nix
    ./sway.nix
    ./git.nix
    ./qutebrowser
    ./gpg.nix
    ./rofi.nix
    ./rnnoise.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    alacritty
    terminal # see flake.nix
    exa
    fd
    _diffr
    kak-pager
    br # bulk rename
    # text manipulation
    sd
    ripgrep
    # desktop
    kanshi
    xfce.thunar
    pass
    dhist
    bmenu
    wdmenu
    wlauncher
    volumesh
    pamixer
    libnotify
    wpass
    screenshotsh
    _gpg-unlock
    xdg-utils
    # media
    yt-dlp
    ffmpeg
    imagemagick
    mpv
    mpc-cli
    helvum
    gimp
    kdenlive
    blender
    libreoffice
    # pulse_sink
    #games
    lutris
    steam
    # chat
    tdesktop
    # discord # I'm using webcord, see home.activation
    thunderbird
    # Theming
    orchis_theme_compact
    papirus_red
    libsForQt5.qtstyleplugins
    qt5.qtsvg
    ## fonts
    liberation_ttf
    hack-font
    font-awesome_5
    fira-code
    nerdfonts_fira_hack
    material-wifi-icons
    # Programming
    vscode
    rustup
    # cargo
    cargo-edit
    cargo-feature
    cargo-watch
    pkgs.unstable.rust-analyzer
    gcc
    nixfmt
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g __accent_color "${accent.color}"
      alias _fish_prompt_accent "_fish_prompt_color '$__accent_color'"
      fzf_key_bindings
    '';
    shellAbbrs = {
      v = "kak";
      ns = "nix develop --command $SHELL";
      # system
      sv = "sudo systemct";
      suv = "sudo systemct --user";
      # git abbrs
      g = "git";
      ga = "git add";
      gs = "git status";
      gsh = "git show";
      gl = "git log";
      gg = "git graph";
      gd = "git diff";
      gds = "git diff --staged";
      gc = "git commit";
      gca = "git commit --all";
      gcf = "git commit --fixup";
      gp = "git push -u origin (git branch --show-current)";
      gw = "git switch";
      gr = "cd (git root)";
      gri = "git rebase --interactive FETCH_HEAD";
    };
    functions = { fish_greeting = ""; };
  };
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  home.file = {
    ".config/fish/conf.d/prompt.fish".source = ./fish_prompt.fish;
    ".local/share/backgrounds".source = ./backgrounds;
  };
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = font.size.small;
        normal = { family = font.mono; };
      };
      colors = {
        primary = {
          background = "${color.bg}";
          foreground = "${color.txt}";
        };
        cursor = {
          text = "#000000";
          cursor = "${accent.color}";
        };
        normal = {
          black = "${color.normal.black}";
          red = "${color.normal.red}";
          green = "${color.normal.green}";
          yellow = "${color.normal.yellow}";
          blue = "${color.normal.blue}";
          magenta = "${color.normal.magenta}";
          cyan = "${color.normal.cyan}";
          white = "${color.normal.white}";
        };
      };
      draw_bold_text_with_bright_colors = false;
      window = {
        opacity = theme.opacity / 100.0;
        dynamic_padding = true;
      };

      hints = {
        alphabet = key.hints;
        enabled = [{
          regex = let
            mimes =
              "(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)";
            # I fucking hate regex, look at this bullshit
            delimiters = ''^\\u0000-\\u001F\\u007F-\\u009F<>"\\s{-}\\^⟨⟩`'';
          in "${mimes}[${delimiters}]+";
          command = "xdg-open";
          post_processing = true;
          mouse = {
            enabled = true;
            mods = "None";
          };
          binding = {
            key = "U";
            mods = "Control|Shift";
          };
        }];
      };
      mouse = { hide_when_typing = true; };
      key_bindings = [
        {
          key = lib.toUpper key.up;
          mode = "Vi|~Search";
          action = "Up";
        }
        {
          key = lib.toUpper key.down;
          mode = "Vi|~Search";
          action = "Down";
        }
        {
          key = lib.toUpper key.left;
          mode = "Vi|~Search";
          action = "Left";
        }
        {
          key = lib.toUpper key.right;
          mode = "Vi|~Search";
          action = "Right";
        }
        {
          key = lib.toUpper key.insertMode;
          mode = "Vi|~Search";
          action = "ScrollToBottom";
        }
        {
          key = lib.toUpper key.insertMode;
          mode = "Vi|~Search";
          action = "ToggleViMode";
        }
        {
          key = lib.toUpper key.next;
          mode = "Vi|~Search";
          action = "SearchNext";
        }
        {
          key = "Up";
          mods = "Control|Shift";
          mode = "~Alt";
          action = "ScrollLineUp";
        }
        {
          key = "Down";
          mods = "Control|Shift";
          mode = "~Alt";
          action = "ScrollLineDown";
        }
        {
          key = "PageUp";
          mods = "Control|Shift";
          mode = "~Alt";
          action = "ScrollHalfPageUp";
        }
        {
          key = "PageDown";
          mods = "Control|Shift";
          mode = "~Alt";
          action = "ScrollHalfPageDown";
        }
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        # {%@@ if key.layout == "colemak" @@%}
        {
          key = "T";
          mode = "Vi|~Search";
          action = "SemanticRightEnd";
        }
        # {%@@ endif @@%}
      ];
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    VOLUME_CHANGE_SOUND =
      "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga";
    FZF_DEFAULT_OPTS = let
      colors = {
        "bg+" = color.bg_light;
        "hl+" = color.normal.green;
        gutter = color.bg;
        prompt = accent.color;
        pointer = accent.color;
        spinner = accent.color;
      };
      makeKeyValue = (k: v: "${k}:${v}");
      makeOptList = lib.mapAttrsToList makeKeyValue colors;
      makeColorValue = lib.strings.concatStringsSep "," makeOptList;
      color_opts = "--color=${makeColorValue}";
      preview_opts =
        "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always {}'";
    in "${preview_opts} ${color_opts}";
  };
  programs.bash = { enable = true; };
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      darkreader
      ublock-origin
      tree-style-tab
      sponsorblock
      duckduckgo-privacy-essentials
    ];
    profiles = {
      main = {
        isDefault = true;
        settings = {
          "devtools.theme" = "dark";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.inTitlebar" = 0;

          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.av1.enabled" = false;
          "gfx.webrender.all" = true;
        };
        userChrome = ''
          #tabbrowser-tabs { visibility: collapse !important; }
        '';
      };
    };
  };
  programs.command-not-found.enable = true;
  home.activation = {
    install_flatpaks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD flatpak $VERBOSE_ARG remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
      $DRY_RUN_CMD flatpak $VERBOSE_ARG install -y flathub io.github.spacingbat3.webcord || true
    '';
  };
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  services.mpd = {
    enable = true;
    musicDirectory = "~/Música";
    extraConfig = ''
      restore_paused "yes"
      auto_update "yes"
      audio_output {
          type    "pulse"
          name    "My Pulse Output"
          mixer_type  "hardware"
      }
      filesystem_charset    "UTF-8"
    '';
  };
  home.pointerCursor = {
    name = "capitaine-cursors";
    size = 32;
    package = pkgs.capitaine-cursors;
  };
  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Red-Dark-Compact";
      package = orchis_theme_compact;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus_red;
    };
  };
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  #   # style.package = pkgs.libsForQt5.qtstyleplugins;
  #   # style.name = "gtk2";
  # };

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      toggle_fps_limit = "F1";

      legacy_layout = "false";
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_load_value = "50,90";
      gpu_load_color = "FFFFFF,FFAA7F,CC0000";
      gpu_text = "GPU";
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;
      core_load_change = true;
      cpu_load_value = "50,90";
      cpu_load_color = "FFFFFF,FFAA7F,CC0000";
      cpu_color = "2e97cb";
      cpu_text = "CPU";
      io_stats = true;
      io_read = true;
      io_write = true;
      io_color = "a491d3";
      swap = true;
      vram = true;
      vram_color = "ad64c1";
      ram = true;
      ram_color = "c26693";
      fps = true;
      engine_color = "eb5b5b";
      gpu_color = "2e9762";
      wine_color = "eb5b5b";
      frame_timing = "1";
      frametime_color = "00ff00";
      media_player_color = "ffffff";
      background_alpha = "0.8";
      font_size = "24";

      background_color = "020202";
      position = "top-left";
      text_color = "ffffff";
      round_corners = "10";
      toggle_hud = "Shift_R+F12";
      toggle_logging = "Shift_L+F12";
      output_folder = "/home/lelgenio";
    };
  };
  systemd.user.services = {
    firefox = {
      Unit = {
        Description = "Firefox Web browser";
        Documentation = "https://github.com/Alexays/Waybar/wiki";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.firefox}/bin/firefox";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    discord = {
      Unit = {
        Description = "Discord Internet voice chat";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "/usr/bin/env flatpak run io.github.spacingbat3.webcord";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    telegram = {
      Unit = {
        Description = "Telegram Internet chat";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.tdesktop}/bin/telegram-desktop";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
    mako = {
      Unit = {
        Description = "Notification daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
  };
}
