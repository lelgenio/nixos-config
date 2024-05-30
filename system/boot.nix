{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-120n.psf.gz";
    packages = [ pkgs.terminus_font ];
    earlySetup = false;
  };

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"

      # Disable password timeout
      "luks.options=timeout=0"
      "rd.luks.options=timeout=0"
      "rootflags=x-systemd.device-timeout=0"
    ];

    initrd.systemd.enable = true;
    loader = {
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      timeout = 0;
      systemd-boot = {
        enable = true;
        # editor = false;
        configurationLimit = 50;
      };
    };
    plymouth = {
      enable = true;
      theme = lib.mkIf (pkgs.uservars.desktop == "sway") "red_loader";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ "red_loader" ]; })
      ];
    };
  };
}
