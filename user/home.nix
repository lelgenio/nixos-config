{ config, pkgs, lib, inputs, ... }:
let inherit (import ./variables.nix) key theme color accent font;

in {
  imports = [
    ./waybar.nix
    ./helix.nix
    ./kakoune.nix
    ./fish.nix
    ./firefox.nix
    ./sway.nix
    ./hyprland.nix
    ./alacritty.nix
    ./git.nix
    ./qutebrowser
    ./gpg.nix
    ./rofi.nix
    ./mpv.nix
    ./mangohud.nix
    ./rnnoise.nix
    inputs.hyprland.homeManagerModules.default
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    terminal # see flake.nix

    ## CLI
    btop
    exa
    fd
    bc
    du-dust
    p7zip
    tealdeer
    micro
    _diffr
    br # bulk rename

    ## text manipulation
    sd
    ripgrep
    translate-shell

    # xfce.thunar
    gnome.nautilus
    pass
    wpass
    _gpg-unlock

    ## media
    yt-dlp
    ffmpeg
    imagemagick
    mpc-cli
    helvum
    gimp
    inkscape
    kdenlive
    blender
    libreoffice
    godot

    ## games
    # lutris-unwrapped
    # steam # It's enabled in the system config

    ## chat
    tdesktop
    thunderbird
    # discord # I'm using webcord, see home.activation

    ## Theming
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

    ## Network
    speedtest-cli
    nmap
    miniupnpc
    deluge


    ## Programming
    vscode
    rustup

    docker-compose
    gnumake
    mariadb
    php74
    nodePackages.intelephense
    nodePackages.typescript-language-server
    nodejs
    nodePackages.yarn
    nodePackages.less
    nodePackages.sass
    nodePackages.less-plugin-clean-css
    nodePackages.uglify-js

    # cargo
    cargo-edit
    cargo-feature
    cargo-watch
    cargo-expand
    cargo-sweep
    pkgs.unstable.rust-analyzer
    gcc
    nixfmt

    trunk
    wasm-bindgen-cli
    sqlx-cli
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

  services.syncthing = {
    enable = true;
    tray.enable = true;
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
  # My bemenu wrapper
  xdg.configFile = {
    "bmenu.conf".text = ''
      set fn "${font.mono} ${toString font.size.small}"

      set tb "${color.bg}${theme.opacityHex}"
      set tf "${accent.color}"

      set fb "${color.bg}${theme.opacityHex}"
      set ff "${color.txt}"

      set nb "${color.bg}${theme.opacityHex}"
      set nf "${color.txt}"
      set hb "${accent.color}"
      set hf "${accent.fg}"
    '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
