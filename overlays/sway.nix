(pkgs: _: {
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      systemctl --user import-environment
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      # systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
      # systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
})
