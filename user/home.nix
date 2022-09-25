{ config, pkgs, lib, inputs, ... }:
let inherit (import ./variables.nix) key theme color accent font;

in {
  imports = [
    ./waybar.nix
    ./helix.nix
    ./kakoune.nix
    ./fish.nix
    ./sway.nix
    ./hyprland.nix
    ./alacritty.nix
    ./git.nix
    ./qutebrowser
    ./gpg.nix
    ./rofi.nix
    ./rnnoise.nix
    inputs.hyprland.homeManagerModules.default
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
    p7zip
    speedtest-cli
    deluge
    _diffr
    kak-pager
    br # bulk rename
    # text manipulation
    sd
    ripgrep
    translate-shell
    # desktop
    kanshi
    # xfce.thunar
    gnome.nautilus
    pass
    wpass
    _gpg-unlock
    # media
    yt-dlp
    ffmpeg
    imagemagick
    mpv
    mpc-cli
    helvum
    gimp
    inkscape
    kdenlive
    blender
    libreoffice
    godot
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
    android-studio
    # cargo
    cargo-edit
    cargo-feature
    cargo-watch
    pkgs.unstable.rust-analyzer
    gcc
    nixfmt
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
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
      package = pkgs.orchis_theme_compact;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus_red;
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
  };
  programs.mpv.enable = true;
  programs.mpv.config = {
    # ytdl-format='best';
    ytdl_path="yt-dlp";
    ytdl-format="bestvideo[height<=1080][vcodec!=vp9]+bestaudio/best";
    ytdl-raw-options="cookies=~/.cache/cookies-youtube-com.txt,mark-watched=";
    osd-fractions=true;
    save-position-on-quit=true;
    keep-open=true;

    cache=true;
    cache-pause-initial=true;
    cache-pause-wait=10;
  };
}
