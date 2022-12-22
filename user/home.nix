{ config, pkgs, lib, inputs, ... }:
let inherit (import ./variables.nix) desktop;
in {
  imports = [
    ./controller.nix
    ./waybar.nix
    ./helix.nix
    ./kakoune.nix
    ./fish.nix
    ./firefox.nix
    ./hyprland.nix
    ./alacritty.nix
    ./git.nix
    ./qutebrowser
    ./gpg.nix
    ./rofi.nix
    ./mpv.nix
    ./mangohud.nix
    ./rnnoise.nix
    ./mimeapps.nix
    ./chat.nix
    ./syncthing.nix
    ./bmenu.nix
    ./fzf.nix
    ./ranger
    ./lf
    ./pass.nix
    ./zathura.nix
    ./man.nix
    inputs.hyprland.homeManagerModules.default
  ] ++ lib.optional (desktop == "sway") ./sway.nix;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    terminal # see flake.nix

    pulse_sink
    pulseaudio

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

    (xfce.thunar.override {
      thunarPlugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin ];
    })
    mate.engrampa
    # gnome.nautilus

    ## games
    # lutris-unwrapped
    # steam # It's enabled in the system config

    ## chat
    thunderbird

    ## Theming
    orchis_theme_compact
    papirus_red
    libsForQt5.qtstyleplugins
    qt5.qtsvg

    ## Network
    speedtest-cli
    nmap
    httpie
    miniupnpc
    deluge

    ## Programming
    vscode
    rustup

    docker-compose
    gnumake
    mariadb
    # php74
    nodePackages.intelephense
    nodePackages.typescript-language-server
    nodejs
    nodePackages.yarn
    nodePackages.less
    nodePackages.sass
    nodePackages.less-plugin-clean-css
    nodePackages.uglify-js

    meson
    ninja

    flow # js lsp server
    nil-lsp # nix lsp server
    clang-tools # c/c++ lsp server

    # cargo
    cargo-edit
    cargo-feature
    cargo-watch
    cargo-expand
    cargo-sweep
    pkgs.unstable.rust-analyzer
    gcc
    rnix-lsp
    nixfmt

    trunk
    wasm-bindgen-cli
    sea-orm-cli
    sqlx-cli
  ];

  home.sessionVariables = {
    VOLUME_CHANGE_SOUND =
      "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga";
  };
  programs.bash = { enable = true; };

  systemd.user.services = {
    steam = {
      Unit = {
        Description = "Steam client";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStartPre = "/usr/bin/env sleep 20s";
        ExecStart = "${pkgs.steam}/bin/steam";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
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
