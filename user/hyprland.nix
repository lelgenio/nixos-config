{ config, pkgs, lib, ... }: {
  config = lib.mkIf (pkgs.uservars.desktop == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = false;
      extraConfig = ''
        monitor=,preferred,auto,1

        input {
            kb_file=
            kb_layout=us(colemak)
            kb_variant=
            kb_model=
            kb_options=
            kb_rules=

            follow_mouse=1

            touchpad {
                natural_scroll=no
            }
        }

        general {
            sensitivity=1.0 # for mouse cursor
            main_mod=SUPER

            gaps_in=5
            gaps_out=10
            border_size=2
            col.active_border=0xffF44336
            col.inactive_border=0x66333333

            apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)

            damage_tracking=full # leave it on full unless you hate your GPU and want to make it suffer
        }

        decoration {
            rounding=5
            blur=1
            blur_size=3 # minimum 1
            blur_passes=1 # minimum 1, more passes = more resource intensive.
            # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
            # if you want heavy blur, you need to up the blur_passes.
            # the more passes, the more you can up the blur_size without noticing artifacts.
        }

        animations {
            enabled=1
            animation=windows,1,7,default
            animation=border,1,10,default
            animation=fade,1,10,default
            animation=workspaces,1,6,default
        }

        dwindle {
            pseudotile=0 # enable pseudotiling on dwindle
        }

        gestures {
            workspace_swipe=no
        }

        # example window rules
        # for windows named/classed as abc and xyz
        #windowrule=move 69 420,abc
        #windowrule=size 420 69,abc
        #windowrule=tile,xyz
        #windowrule=float,abc
        #windowrule=pseudo,abc
        #windowrule=monitor 0,xyz

        # example binds
        bind=SUPER,Q,exec,kitty
        bind=SUPER,RETURN,exec,alacritty
        bind=SUPER,x,killactive,
        bind=SUPER,M,exit,
        # bind=SUPER,E,exec,dolphin
        bind=SUPER,V,togglefloating,
        bind=SUPER,s,exec,wlauncher
        bind=SUPER,P,pseudo,

        bind=SUPER,f,fullscreen

        bind=SUPER,n,movefocus,l
        bind=SUPER,o,movefocus,r
        bind=SUPER,i,movefocus,u
        bind=SUPER,e,movefocus,d

        bind=SUPER,left,movefocus,l
        bind=SUPER,right,movefocus,r
        bind=SUPER,up,movefocus,u
        bind=SUPER,down,movefocus,d

        bind=SUPER,1,workspace,1
        bind=SUPER,2,workspace,2
        bind=SUPER,3,workspace,3
        bind=SUPER,4,workspace,4
        bind=SUPER,5,workspace,5
        bind=SUPER,6,workspace,6
        bind=SUPER,7,workspace,7
        bind=SUPER,8,workspace,8
        bind=SUPER,9,workspace,9
        bind=SUPER,0,workspace,10

        bind=ALT,1,movetoworkspace,1
        bind=ALT,2,movetoworkspace,2
        bind=ALT,3,movetoworkspace,3
        bind=ALT,4,movetoworkspace,4
        bind=ALT,5,movetoworkspace,5
        bind=ALT,6,movetoworkspace,6
        bind=ALT,7,movetoworkspace,7
        bind=ALT,8,movetoworkspace,8
        bind=ALT,9,movetoworkspace,9
        bind=ALT,0,movetoworkspace,10

        bind=SUPER,u,workspace,e-1
        bind=SUPER,y,workspace,e+1

        bind=SUPER,mouse_down,workspace,e-1
        bind=SUPER,mouse_up,workspace,e+1
      '';
    };
    home.file.".config/eww".source = ./eww;
    home.packages = with pkgs; [ eww-wayland jq ];
  };
}
