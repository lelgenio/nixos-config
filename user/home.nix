{ config, pkgs, ... }:
let 
  key = {
      left = "n";
      down = "e";
      up = "i";
      right = "o";
    tabL = "u";
    tabR = "Y";
  };
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
    ripgrep
    yt-dlp
    ffmpeg
    imagemagick
    mpv
  ];

  programs.fish.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   darkreader
    #   ublock-origin
    # ];
    # profiles = {
    #   main = {
    #     isDefault = true;
    #     settings = {
    #       "devtools.theme" = "dark";
    #       "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     };
    #     userChrome = ''
    #       #tabbrowser-tabs { visibility: collapse !important; } 
    #     '';
    #   };
    # };
  };

  programs.command-not-found.enable = true;


  # home.file = {
  #   ".config/sway/config".source = ./sway;
  # };

programs.waybar = {
  enable = true;
  settings = [{
    layer = "top";
    modules-left = [ "sway/workspaces" ];
    modules-center = [
      "clock"
    ];
    modules-right = [];
  }];
};


  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [{ command = "waybar"; }];
      input."type:touchpad" = {
        # Disable While Typing
        dwt = "disabled";
        natural_scroll = "enabled";
        tap = "enabled";
      };
      input."*" = {
        xkb_layout = "us(colemak)";
        xkb_options = "lv3:lsgt_switch,grp:shifts_toggle";
        xkb_numlock = "enabled";
        repeat_rate = "30";
        repeat_delay = "200";
      };
      keybindings =
      let 
        mod = "Mod4";
        menu = "bemenu-run";
        terminal = "alacritty";
      in
      {
        "${mod}+Prior" = "workspace prev_on_output";
        "${mod}+Next" = "workspace next_on_output";
        "${mod}+${key.tabL}" = "workspace prev_on_output";
        "${mod}+${key.tabR}" = "workspace next_on_output";

        XF86AudioRaiseVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
        XF86AudioLowerVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
        XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        XF86AudioMicMute = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        # Control media
        XF86AudioPlay = "exec playerctl play-pause";
        XF86AudioPause = "exec playerctl play-pause";
        XF86AudioNext = "exec playerctl next";
        XF86AudioPrev = "exec playerctl previous";


         "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+s" = "exec ${menu}";

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

          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+a" = "focus parent";

          # "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          # "${mod}+e" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";

          "${mod}+Shift+1" =
            "move container to workspace number 1";
          "${mod}+Shift+2" =
            "move container to workspace number 2";
          "${mod}+Shift+3" =
            "move container to workspace number 3";
          "${mod}+Shift+4" =
            "move container to workspace number 4";
          "${mod}+Shift+5" =
            "move container to workspace number 5";
          "${mod}+Shift+6" =
            "move container to workspace number 6";
          "${mod}+Shift+7" =
            "move container to workspace number 7";
          "${mod}+Shift+8" =
            "move container to workspace number 8";
          "${mod}+Shift+9" =
            "move container to workspace number 9";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          "${mod}+Shift+c" = "reload";
          # "${mod}+Shift+e" =
          #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${mod}+r" = "mode resize";
      }
      # // map (key: "$mod+${key} workspace prev_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
      # // map (key: "$mod+${key} workspace next_on_output") [ key.tabL "bracketleft" "Prior" "button9" "button4" ]
      ;
      terminal = pkgs.alacritty.executable;

    };
  };
}
