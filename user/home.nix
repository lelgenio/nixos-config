{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    ./controller.nix
    ./waybar
    ./helix.nix
    ./kakoune
    ./vscode
    ./fish
    ./firefox.nix
    ./alacritty.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./rofi.nix
    ./mpv.nix
    ./mangohud.nix
    ./pipewire.nix
    ./mimeapps.nix
    ./desktop-entries.nix
    ./chat.nix
    ./syncthing.nix
    ./bmenu.nix
    ./fzf.nix
    ./ranger
    ./lf
    ./pass.nix
    ./pqiv.nix
    ./zathura.nix
    ./man.nix
    ./mpd.nix
    ./sway
    ./gnome.nix
    ./thunar.nix
    ./xdg-dirs.nix
    inputs.nix-index-database.hmModules.nix-index
    ../settings
  ];

  my = import ./variables.nix;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lelgenio";
  home.homeDirectory = "/home/lelgenio";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # home-manager

    terminal # see flake.nix

    pulse_sink
    pulseaudio

    ## CLI
    eza
    fd
    gavin-bc
    file
    jq
    du-dust
    p7zip
    tealdeer
    micro
    _diffr
    br # bulk rename

    comma

    # System monitors
    (btop.override { cudaSupport = true; })
    amdgpu_top
    inxi
    dmidecode
    ncdu

    ## text manipulation
    sd
    ripgrep
    translate-shell
    lipsum
    par

    mate.engrampa
    # gnome.nautilus

    ## games
    # lutris-unwrapped
    # steam # It's enabled in the system config
    tlauncher
    gamescope
    glxinfo
    vulkan-tools

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
    nicotine-plus

    ## Nix secrets management
    inputs.agenix.packages.x86_64-linux.default

    ## Programming
    # rustup

    docker-compose
    gnumake
    mariadb

    nodePackages.intelephense
    nodePackages.typescript-language-server
    flow # js lsp server
    nil # nix lsp server
    clang-tools # c/c++ lsp server
    rust-analyzer # rust analyzer

    blade-formatter
    nixfmt-rfc-style
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    ".local/share/backgrounds" = {
      source = ./backgrounds;
      recursive = true;
    };
  };
  home.sessionVariables = {
    VOLUME_CHANGE_SOUND = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga";
  };
  programs.bash = {
    enable = true;
  };

  xdg.defaultApplications = {
    enable = true;
    text-editor = lib.mkDefault "kak.desktop";
    image-viewer = lib.mkDefault "pqiv.desktop";
    video-player = lib.mkDefault "mpv.desktop";
    web-browser = lib.mkDefault "firefox.desktop";
    document-viewer = lib.mkDefault "org.pwmt.zathura.desktop";
    file-manager = lib.mkDefault "thunar.desktop";
    archive-manager = "engrampa.desktop";
    email-client = lib.mkDefault "thunderbird.desktop";
    torrent-client = lib.mkDefault "torrent.desktop";
  };

  wayland.windowManager.sway.extraConfig =
    lib.optionalString (osConfig.networking.hostName or "" == "monolith")
      ''
        exec steam
        exec obs --startreplaybuffer --disable-shutdown-check
        exec deluge-gtk
        exec nicotine
      '';

  systemd.user.services.rm-target = {
    Unit = {
      Description = "Remove directories named 'target'";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rm-target" ''
        sudo ${pkgs.fd}/bin/fd -td -u '^\.?target$' "$HOME" -x rm -vrf --
      '';
    };
  };
  systemd.user.timers.rm-target = {
    Unit = {
      Description = "Remove directories named 'target'";
    };
    Timer = {
      OnCalendar = "weekly";
      Unit = "rm-target.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
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
