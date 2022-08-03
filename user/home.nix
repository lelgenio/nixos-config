{ config, pkgs, lib, ... }:
let
  key = {
    left = "n";
    down = "e";
    up = "i";
    right = "o";
    tabL = "u";
    tabR = "Y";
  };
  font = {
    mono = "Hack Nerd Font";
    interface = "Liberation Sans";
    size = {
      small = "12";
      medium = "14";
      big = "16";
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
  papirus_red = (pkgs.unstable.papirus-icon-theme.override { color = "red"; });
  orchis_theme_compact =
    (pkgs.orchis-theme.override { tweaks = [ "compact" "solid" ]; });
  nerdfonts_fira_hack =
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; });
  accent = accents.red;
  theme = themes.dark;
  color = theme.color;
  pulse_sink = pkgs.writeShellScriptBin "pulse_sink" ''
    #!/bin/sh
    output=$(printf "HDMI\nHeadphones" | ${bmenu}/bin/bmenu -b)
    vol=$(${pkgs.pamixer}/bin/pamixer --get-volume)
    case "$output" in
        HDMI)
            pactl set-default-sink alsa_output.pci-0000_07_00.1.hdmi-stereo-extra1
            ;;
        Headphones)
            pactl set-default-sink alsa_output.pci-0000_09_00.4.analog-stereo
            ;;
    esac
    ${pkgs.pamixer}/bin/pamixer --set-volume "$vol"
  '';
  bmenu = pkgs.writeScriptBin "bmenu" ''
    #!${pkgs.fish}/bin/fish

    # wrapper around bemenu
    # bmenu *       - use as dmenu, -p for custom prompt (man bemenu)
    # bmenu run     - select from .desktop files and run it
    # bmenu start   - internal option

    set swaymsg ${pkgs.sway}/bin/swaymsg
    set swaymsg ${pkgs.sway}/bin/swaymsg

    if test "$argv[1]" = "run"
        test -n "$argv[2]" && set t "$argv[2]" || set t "terminal"

        test -n "$i3SOCK" && set wrapper 'i3-msg exec --'
        test -n "$SWAYSOCK" && set wrapper 'swaymsg exec --'

        exec ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
            --dmenu="bmenu start -p Iniciar:" \
            --term "$t" \
            --wrapper="$wrapper" \
            --no-generic
    end

    if test -n "$SWAYSOCK"
        swaymsg -t get_tree |
            ${pkgs.jq}/bin/jq -je '..|select(.focused? and .fullscreen_mode? == 1)|""' &&
            ${pkgs.sway}/bin/swaymsg -q fullscreen off &&
            set fullscreen

        ${pkgs.sway}/bin/swaymsg -t get_outputs |
            ${pkgs.jq}/bin/jq -r 'map(.focused)|reverse|index(true)' |
            read focused_output

        test -n "$focused_output"
        and set focused_output "-m $focused_output"
    end

    function clean_exit
        set -q fullscreen
        and swaymsg -q fullscreen on &
    end

    trap clean_exit EXIT

    # t  title
    # f  filter
    # n  normal
    # h  highlighted
    # s  selected
    # sc scrollbar

        set fn "${font.mono} ${font.size.small}"

        set tb "${color.bg}${theme.opacityHex}"
        set tf "${accent.color}"

        set fb "${color.bg}${theme.opacityHex}"
        set ff "${color.txt}"

        set nb "${color.bg}${theme.opacityHex}"
        set nf "${color.txt}"
        set hb "${accent.color}"
        set hf "${accent.fg}"

    ${pkgs.dhist}/bin/dhist wrap -- ${pkgs.bemenu}/bin/bemenu \
        $focused_output\
        --ignorecase\
        --bottom\
        --no-overlap\
        --list 20\
        --prefix '>'\
        --fn "$fn"\
        --tb "$tb" --tf "$tf" \
        --fb "$fb" --ff "$ff" \
        --nb "$nb" --nf "$nf" \
        --hb "$hb" --hf "$hf" \
        $argv

    # vim: ft=fish
  '';
  volumesh = pkgs.writeShellScriptBin "volumesh" (builtins.readFile ./scripts/volumesh);
in {
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
    exa
    fd
    # text manipulation
    pkgs.unstable.helix
    sd
    ripgrep
    # desktop
    kanshi
    xfce.thunar
    pass
    dhist
    bmenu
    volumesh
    pamixer
    libnotify
    # media
    yt-dlp
    ffmpeg
    imagemagick
    mpv
    mpc-cli
    pulse_sink
    #games
    lutris
    steam
    # chat
    tdesktop
    # discord # I'm using webcord, see home.activation
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
    # Programming
    vscode
    cargo
    rust-analyzer
    gcc
    nixfmt
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g __accent_color "${accent.color}"
      alias _fish_prompt_accent "_fish_prompt_color '$__accent_color'"
    '';
    shellAbbrs = {
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
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  home.file = {
    # ".config/sway/config".source = ./sway;
    ".config/fish/conf.d/prompt.fish".source = ./fish_prompt.fish;
    ".local/share/backgrounds".source = ./backgrounds;
  };
  programs.alacritty = {
    enable = true;
    settings = {
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
    };
  };
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    settings = {
      theme = "gruvbox";
      editor = {
        whitespace.render = "all";
        whitespace.characters = {
          space = "·";
          tab = "→";
          newline = "¬";
        };
      };
      keys.normal = {
        # basic movement
        n = "move_char_left";
        e = "move_line_down";
        i = "move_line_up";
        o = "move_char_right";
        # search
        l = "search_next";
        L = "search_prev";
        # edits
        s = "insert_mode";
        # open newline
        h = "open_below";
        H = "open_above";
        # selections
        k = "select_regex";
        K = "split_selection";
        "C-k" = "split_selection_on_newline";
        # goto mode
        g.n = "goto_line_start";
        g.o = "goto_line_end";
      };
      keys.select = {
        # basic movement
        n = "extend_char_left";
        e = "extend_line_down";
        i = "extend_line_up";
        o = "extend_char_right";
        # search
        l = "search_next";
        L = "search_prev";
        # edits
        s = "insert_mode";
        # open newline
        h = "open_below";
        H = "open_above";
        # selections
        k = "select_regex";
        K = "split_selection";
        "C-k" = "split_selection_on_newline";
        # goto mode
        g.n = "goto_line_start";
        g.o = "goto_line_end";
      };
      keys.insert = { "A-k" = "normal_mode"; };
    };
  };
  home.sessionVariables = { 
    EDITOR = "hx";
    VOLUME_CHANGE_SOUND = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga";
  };
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
        };
        userChrome = ''
          #tabbrowser-tabs { visibility: collapse !important; }
        '';
      };
    };
  };
  programs.command-not-found.enable = true;
  # home.file = {
  #   ".config/sway/config".source = ./sway;
  # };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = [{
      layer = "top";
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" ];
      network = {
        interval = 5;
        tooltip = false;
        on-click = "terminal iwd";
        format-wifi = "{icon}";
        format-icons = [ "" "" "" "" "" ];
        format-ethernet = "";
        format-linked = "";
        format-disconnected = "";
      };
      "sway/workspaces" = {
        enable-bar-scroll = true;
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
          urgent = "";
          focused = "";
          default = "";
        };
      };
      clock = {
        interval = 60;
        format = "<b>{:%H:%M %a %d/%m}</b>";
        tooltip = false;
      };
      pulseaudio = {
        interval = 5;
        tooltip = false;
        scroll-step = 10;
        format = "{icon}";
        format-bluetooth = "";
        format-bluetooth-muted = "";
        format-muted = "ﱝ";
        format-icons = {
          headphone = [ " 奄" " 奔" " 墳" ];
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "奄" "奔" "墳" ];
        };
        on-click = "pavucontrol";
        on-click-right = "pulse-sink";
      };
    }];
    style = ''
      /* {%@@ set bg_rgb = hex2rgb(color.bg) @@%} */
      * {
              font: ${font.size.medium}px "${font.interface}", Font Awesome, Fira Code Nerd Font;
              border-radius:0;
              margin:0;
              padding: 0;
              transition-duration:0;
      }
      window#waybar {
              /* background-color: rgba(30,30,30,.9); */
              transition-duration: .5s;
              /* TODO: background opacity */
              background-color: ${color.bg};
              /*{%@@ if bar_pos == "top" @@%}
                      border-bottom:
              {%@@ else @@%}
                      border-top:
              {%@@ endif @@%}*/
              border-bottom:
                  2px solid ${color.bg_dark};
      }
      window#waybar.solo {
              background-color: ${color.bg};
      }
      #workspaces button {
              color: ${color.bg_light};
              min-width:50px;
              background-color: transparent;
              border: 3px solid transparent;
      }
      #workspaces button.focused {
              color: ${color.txt};
              /*{%@@ if bar_pos == "top" @@%}
                      border-top:
              {%@@ else @@%}
                      border-bottom:
              {%@@ endif @@%}*/
                      border-top:
                      3px solid ${accent.color};
              /* border-bottom: 3px solid transparent; */
      }
      /*Window Title*/
      #window {
              color: ${color.txt};
              margin:0 4px;
      }
      #mode {
              color: ${accent.color};
      }
      #mpd,
      #custom-mpd,
      #tray,
      #clock,
      #network,
      #battery,
      #backlight,
      #bluetooth,
      #pulseaudio,
      #custom-mail,
      #custom-spigot,
      #custom-updates,
      #custom-weather,
      #custom-unpushed,
      #custom-transmissionD,
      #custom-transmissionS,
      #custom-delugeD,
      #custom-delugeS,
      #custom-caffeine
      {
              margin: 0 7px;
              color: ${color.txt};
              opacity:.7;
      }
      #battery{
              margin-right:15px;
      }
      #clock,
      #custom-weather
      {
              font-size: ${font.size.big}px;
      }
      #network,
      #pulseaudio,
      #custom-caffeine
      {
              margin-top:-1px;
              font-size:16px;
      }
      #mpd,
      #window,
      #workspaces
      {
              font-weight:normal;
      }
      #custom-unpushed,
      #custom-recording {
              min-width:15px;
              color: #ee4040;
      }
      #tray {
              padding: 0;
              margin: 0;
      }
      #language {
              font-size: ${font.size.medium}px;
              color: ${color.bg_light};
      }
      #custom-sleep {
              color: ${accent.color};
              font-size: ${font.size.big}px;
              font-weight: bold;
      }
    '';
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [ ];
      window.titlebar = false;
      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 5;
      };
      colors = let
        acc = accent.color;
        fg_acc = accent.fg;
        fg_color = color.txt;
        bg_color = color.bg_dark;
        alert = "#000000";
        client = border: background: text: indicator: childBorder: {
          inherit border background text indicator childBorder;
        };
      in {
        focused = client acc acc fg_acc acc acc;
        focusedInactive = client bg_color bg_color fg_color bg_color bg_color;
        unfocused = client bg_color bg_color fg_color bg_color bg_color;
        urgent = client alert alert fg_color alert alert;
      };
      output = { "*" = { bg = "${theme.background} fill"; }; };
      input."type:touchpad" = {
        # Disable While Typing
        dwt = "disabled";
        natural_scroll = "enabled";
        tap = "enabled";
      };
      input."*" = {
        xkb_layout = "us(colemak),br";
        xkb_options = "lv3:lsgt_switch,grp:shifts_toggle";
        xkb_numlock = "enabled";
        repeat_rate = "30";
        repeat_delay = "200";
      };
      assigns = {
        "10" = [
          { app_id = ".*[Tt]elegram.*"; }
          { class = ".*[Tt]elegram.*"; }
          { class = "Jitsi Meet"; }
          { class = "discord"; }
          { title = "Discord"; }
          { class = "WebCord"; }
        ];
      };
      modes = let return_mode = lib.mapAttrs (k: v: "${v}; mode default");
      in {
        audio = {
              ${key.tabL} = "volumes decrease";
        } // return_mode {
          "space" = "exec mpc toggle";
          "escape" = "";
          "s" = "exec ${pulse_sink}/bin/pulse_sink";
        };
      };
      floating.modifier = "Mod4";
      keybindings = let
        mod = "Mod4";
        menu = "bmenu run";
        terminal = "alacritty";
        workspace_binds = {
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";
        };
        prev_next_binds = let
          join_dict_arr = builtins.foldl' (a: v: a // v) { };
          maybe_window = key:
            if (lib.strings.hasInfix "button" key) then
              "--whole-window"
            else
              "";
          prev_binds = map (key: {
            "${maybe_window key} ${mod}+${key}" = "workspace prev_on_output";
          }) [ key.tabL "bracketleft" "Prior" "button9" "button4" ];
          next_binds = map (key: {
            "${maybe_window key} ${mod}+${key}" = "workspace next_on_output";
          }) [ key.tabR "bracketright" "Next" "button8" "button5" ];
        in join_dict_arr (prev_binds ++ next_binds);
        movement_binds = {
          "${mod}+${key.left}" = "focus left";
          "${mod}+${key.down}" = "focus down";
          "${mod}+${key.up}" = "focus up";
          "${mod}+${key.right}" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+Shift+${key.left}" = "move left";
          "${mod}+Shift+${key.down}" = "move down";
          "${mod}+Shift+${key.up}" = "move up";
          "${mod}+Shift+${key.right}" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Control+${key.left}" = "resize shrink width";
          "${mod}+Control+${key.down}" = "resize grow height";
          "${mod}+Control+${key.up}" = "resize shrink height";
          "${mod}+Control+${key.right}" = "resize grow width";
          "${mod}+Control+Left" = "resize shrink width";
          "${mod}+Control+Down" = "resize grow height";
          "${mod}+Control+Up" = "resize shrink height";
          "${mod}+Control+Right" = "resize grow width";
          "${mod}+mod1+${key.left}" = "focus output left";
          "${mod}+mod1+${key.down}" = "focus output down";
          "${mod}+mod1+${key.up}" = "focus output up";
          "${mod}+mod1+${key.right}" = "focus output right";
          "${mod}+mod1+Left" = "focus output left";
          "${mod}+mod1+Down" = "focus output down";
          "${mod}+mod1+Up" = "focus output up";
          "${mod}+mod1+Right" = "focus output right";
          "${mod}+mod1+Shift+${key.left}" = "move workspace output left";
          "${mod}+mod1+Shift+${key.down}" = "move workspace output down";
          "${mod}+mod1+Shift+${key.up}" = "move workspace output up";
          "${mod}+mod1+Shift+${key.right}" = "move workspace output right";
          "${mod}+mod1+Shift+Left" = "move workspace output left";
          "${mod}+mod1+Shift+Down" = "move workspace output down";
          "${mod}+mod1+Shift+Up" = "move workspace output up";
          "${mod}+mod1+Shift+Right" = "move workspace output right";
        };
        audio_binds = {
          XF86AudioRaiseVolume =
            "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
          XF86AudioLowerVolume =
            "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
          XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioMicMute =
            "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          # Control media
          XF86AudioPlay = "exec playerctl play-pause";
          XF86AudioPause = "exec playerctl play-pause";
          XF86AudioNext = "exec playerctl next";
          XF86AudioPrev = "exec playerctl previous";
        };
        system_binds = { "Ctrl+${mod}+z" = "exec systemctl suspend"; };
      in {
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Ctrl+Return" = "exec thunar";
        "${mod}+x" = "kill";
        "${mod}+s" = "exec ${menu}";
        "${mod}+m" = "mode audio";
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+a" = "focus parent";
        # "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        # "${mod}+e" = "layout toggle split";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+c" = "reload";
        # "${mod}+Shift+e" =
        #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+r" = "mode resize";
      } // workspace_binds // prev_next_binds // movement_binds // audio_binds
      // system_binds
      # // map (key: "$mod+${key} workspace prev_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
      # // map (key: "$mod+${key} workspace next_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
      ;
      terminal = pkgs.alacritty.executable;
    };
  };
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 360;
        command = "swaylock -f";
      }
      {
        timeout = 1800;
        command = "mpc status | grep \"^\[playing\]\" > /dev/null || swaymsg \"output * dpms off\"";
        resumeCommand = "swaymsg \"output * dpms on\"";
      }
    ];
    events = [{
      event = "before-sleep";
      command = "swaylock -f";
    }];
  };
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };
  services.kanshi = {
    enable = true;
    profiles = {
      sedetary = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
            position = "1920,312";
          }
          {
            criteria = "HDMI-A-1";
            position = "0,0";
          }
        ];
        exec = [ "xrdb .Xresources" ];
      };
      nomad = {
        outputs = [{
          criteria = "eDP-1";
          status = "enable";
          position = "1920,312";
        }];
        exec = [ "xrdb .Xresources" ];
      };
    };
  };
  programs.mako = {
    enable = true;
    borderSize = 2;
    padding="5";
    margin="15";
    layer = "overlay";

    backgroundColor = color.bg;
    borderColor = accent.color;
    progressColor = "over ${accent.color}88";

    defaultTimeout=10000;
      # # {{@@ header() @@}}
      # # text
      # font={{@@ font.interface @@}} {{@@ font.size.small @@}}
      # text-color={{@@ color.txt @@}}

      # # colors
      # background-color={{@@ color.bg @@}}{{@@ opacity | clamp_to_hex @@}}
      # border-color={{@@ accent_color @@}}
      # progress-color=over {{@@ accent_color @@}}88

      # # decoration
      # border-size=2
      # padding=5
      # margin=15

      # # features
      # icons=1
      # markup=1
      # actions=1
      # default-timeout=10000

      # # position
      # layer=overlay

      # [app-name=volumesh]
      # default-timeout=5000
      # group-by=app-name
      # format=<b>%s</b>\n%b

      # [app-name=dotdrop]
      # default-timeout=5000
      # group-by=app-name
      # format=<b>%s</b>\n%b

      # # vim: ft=ini


  };
  home.activation = {
   install_flatpaks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD flatpak $VERBOSE_ARG remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 
      $DRY_RUN_CMD flatpak $VERBOSE_ARG install -y flathub io.github.spacingbat3.webcord 
    '';
  };
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  services.mpd = {
    enable = true;
    musicDirectory = "~/Música";
  };
  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    x11.enable = true;
    gtk.enable = true;
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
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.package = pkgs.libsForQt5.qtstyleplugins;
    style.name = "gtk2";
  };

  programs.mangohud.enable = true;
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
