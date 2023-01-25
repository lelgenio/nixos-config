{ config, pkgs, lib, inputs, ... }: {
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
    ./email.nix
    ./syncthing.nix
    ./vdir.nix
    ./bmenu.nix
    ./fzf.nix
    ./ranger
    ./lf
    ./pass.nix
    ./pqiv.nix
    ./zathura.nix
    ./man.nix
    ./mpd.nix
    ./sway.nix
    ./thunar.nix
    inputs.hyprland.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # home-manager

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

    comma

    ## text manipulation
    sd
    ripgrep
    translate-shell

    mate.engrampa
    # gnome.nautilus

    ## games
    # lutris-unwrapped
    steam # It's enabled in the system config
    gamescope
    protontricks
    (dzgui.overrideAttrs (_: { src = inputs.dzgui; }))

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

    ## Nix secrets management
    inputs.agenix.defaultPackage.x86_64-linux

    ## Programming
    vscode
    rustup

    devenv
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
    nixpkgs-fmt

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

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };


  xdg.userDirs =
    let
      HOME = config.home.homeDirectory;
    in
    {
      enable = true;
      createDirectories = true;

      desktop = "${HOME}/Área de trabalho";
      documents = "${HOME}/Documentos";
      download = "${HOME}/Downloads";
      music = "${HOME}/Música";
      pictures = "${HOME}/Imagens";
      publicShare = "${HOME}/Público";
      templates = "${HOME}/Modelos";
      videos = "${HOME}/Vídeos";
    };

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
