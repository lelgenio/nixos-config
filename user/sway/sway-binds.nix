{ config, pkgs, ... }:
let
  inherit (config.my)
    key
    accent
    font
    theme
    ;
  inherit (theme) color;
  inherit (pkgs) lib;

  mod = "Mod4";
  menu = "wlauncher";
  terminal = "alacritty";

  _lock = pkgs.writeShellScriptBin "_lock" ''
    ${pkgs.sway}/bin/swaymsg mode default
    ${pkgs.swaylock}/bin/swaylock -f
  '';
  _suspend = pkgs.writeShellScriptBin "_suspend" ''
    ${pkgs.sway}/bin/swaymsg mode default
    systemctl --user start swayidle.service
    systemctl suspend
  '';

  # mod+1 to swich to workspace 1
  # mod+shift+1 to move to workspace 1
  workspace_binds = lib.forEachMerge (lib.range 1 10) (
    i:
    let
      key = toString (lib.mod i 10);
      workspaceNumber = toString i;
    in
    {
      "${mod}+${key}" = "workspace number ${workspaceNumber}";
      "${mod}+Shift+${key}" = "move container to workspace number ${workspaceNumber}";
    }
  );

  prev_next_binds =
    let
      maybe_window = key: if (lib.strings.hasInfix "button" key) then "--whole-window" else "";
      makePrevNextBindFunction = (
        prev_or_next:
        map (key: {
          "${maybe_window key} ${mod}+${key}" = "workspace ${prev_or_next}_on_output";
        })
      );
      prev_binds = makePrevNextBindFunction "prev" [
        key.tabL
        "bracketleft"
        "Prior"
        "button9"
        "button4"
        "Shift+Tab"
      ];
      next_binds = makePrevNextBindFunction "next" [
        key.tabR
        "bracketright"
        "Next"
        "button8"
        "button5"
        "Tab"
      ];
    in
    lib.mergeAttrsSet (prev_binds ++ next_binds);

  # focus, move, resize, (focus and move output)
  # for every direction with both arrow keys and vim keys
  movement_binds =
    let
      directions = [
        "Left"
        "Up"
        "Right"
        "Down"
      ];
      makeVimKeys = (k: key.${lib.toLower k});
      makeArrowKeys = (k: k);
      makeResizeCommand =
        direction:
        {
          Left = "shrink width 20px";
          Up = "shrink height 20px";
          Right = "grow width 20px";
          Down = "grow height 20px";
        }
        .${direction};
    in
    lib.forEachMerge
      [
        makeVimKeys
        makeArrowKeys
      ]
      (
        prefixFun:
        lib.forEachMerge directions (
          direction:
          let
            resize_cmd = makeResizeCommand direction;
            keyBind = prefixFun direction;
          in
          {
            #  Move focus
            "${mod}+${keyBind}" = "focus ${direction}";
            #  Move window
            "${mod}+Shift+${keyBind}" = "move ${direction}";
            #  Resize window
            "${mod}+Control+${keyBind}" = "resize ${resize_cmd}";
            #  focus output
            "${mod}+mod1+${keyBind}" = "focus output ${direction}";
            #  Move workspace to output
            "${mod}+mod1+Shift+${keyBind}" = "move workspace output ${direction}";
          }
        )
      );

  parenting_binds = {
    "${mod}+equal" = "focus parent";
    "${mod}+minus" = "focus child";
    "${mod}+r" = "layout toggle split";
    "${mod}+t" = "layout toggle split tabbed stacking";
    "${mod}+b" = "splith";
    "${mod}+v" = "splitv";
    "${mod}+a" = "focus parent";

    ## TODO:
    # "${mod}+Shift+minus" = "move scratchpad";
    # "${mod}+minus" = "scratchpad show";
  };

  audio_binds = {
    XF86AudioRaiseVolume = "exec volumesh -i 10";
    XF86AudioLowerVolume = "exec volumesh -d 10";
    XF86AudioMute = "exec volumesh -t";
    XF86AudioMicMute = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    # Control media
    XF86AudioPlay = "exec playerctl play-pause";
    XF86AudioPause = "exec playerctl play-pause";
    XF86AudioNext = "exec playerctl next";
    XF86AudioPrev = "exec playerctl previous";
  };

  system_binds = {
    "--locked Ctrl+${mod}+z" = "exec ${_suspend}/bin/_suspend";
    "${mod}+Alt+c" = "exec ${pkgs._sway_idle_toggle}/bin/_sway_idle_toggle";
  };

  screenshot_binds = {
    # Screens to file
    "Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh def";
    # Screen area to file
    "Shift+Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh area";
    # Screen area to clipboard
    "Control+Shift+Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh area-clip";
    # Focused monitor to clipboard
    "Control+Print" = "exec ${pkgs.screenshotsh}/bin/screenshotsh clip";
  };

  screen_binds = {
    "XF86MonBrightnessDown" = "exec brightnessctl --min-value=1 set 5%-";
    "XF86MonBrightnessUp" = "exec brightnessctl --min-value=1 set 5%+";
    "${mod}+l" = lib.getExe _lock;
  };

  other_binds = {
    "${mod}+p" = "exec ${pkgs.wpass}/bin/wpass";
    "${mod}+s" = "exec ${menu}";
    "${mod}+g" = "exec ${pkgs.demoji}/bin/demoji --lang pt --fallback --copy -- ${pkgs.wdmenu}/bin/wdmenu";
    "${mod}+c" = "exec ${pkgs.color_picker}/bin/color_picker";
    "${mod}+Return" = "exec ${terminal}";
    "${mod}+Ctrl+Return" = "exec thunar";
    "${mod}+Shift+s" = ''
      exec grim - | satty --filename - --fullscreen --output-filename "$(xdg-user-dir PICTURES)"/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
    '';
    "${mod}+Ctrl+v" = "exec wl-paste | tesseract -l por - - | wl-copy";
    "${mod}+k" = "exec showkeys";
    "${mod}+Alt+x" = "exec pkill wl-crosshair || exec wl-crosshair";
    "${mod}+x" = "kill";
    "${mod}+m" = "mode audio";
    "${mod}+escape" = "mode passthrough;exec notify-send 'Passthrough on'";
    "${mod}+ctrl+k" = "exec swaymsg input type:pointer events disabled";
    "${mod}+ctrl+shift+k" = "exec swaymsg input type:pointer events enabled";
    "${mod}+f" = "fullscreen toggle";
    "${mod}+Shift+space" = "floating toggle";
    "${mod}+space" = "focus mode_toggle";
    "${mod}+ctrl+space" = "sticky toggle";
    "${mod}+Shift+c" = "reload";
    # "${mod}+Shift+e" =
    #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

    # https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/1731
    "${mod}+Ctrl+Shift+Alt+l" = "exec xdg-open https://www.linkedin.com";
  };
in
{
  wayland.windowManager.sway.config.keybindings = lib.mergeAttrsSet [
    other_binds
    workspace_binds
    prev_next_binds
    movement_binds
    audio_binds
    system_binds
    parenting_binds
    screenshot_binds
    screen_binds
  ];
}
