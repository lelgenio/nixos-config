{ config, pkgs, inputs, ... }: {
  console = {
    font = "ter-132n";
    packages = [pkgs.terminus_font];
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
    ];

    initrd.systemd.enable = true;
    loader = {
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      timeout = 0;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot = {
        enable = true;
        # editor = false;
        configurationLimit = 50;
      };
    };
    plymouth = {
      enable = true;
      theme = "red_loader";
      themePackages = [
        pkgs.plymouth-theme-red
      ];
    };
  };
}