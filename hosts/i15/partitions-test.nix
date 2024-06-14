{
  config,
  lib,
  pkgs,
  ...
}:
pkgs.makeDiskoTest {
  name = "test-disko-i15";
  disko-config = ./partitions.nix;
  enableOCR = true;
  bootCommands = ''
    machine.wait_for_text("[Pp]assphrase for")
    machine.send_chars("secretsecret\n")
  '';
  extraTestScript = ''
    machine.succeed("cryptsetup isLuks /dev/vda2");
    machine.succeed("mountpoint /home");
  '';
}
