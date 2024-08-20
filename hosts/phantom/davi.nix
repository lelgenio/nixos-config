{ pkgs, ... }:
{
  users.users.davikiwi = {
    isNormalUser = true;
    description = "Davi";
    hashedPassword = "$y$j9T$0e/rczjOVCy7PuwC3pG0V/$gTHZhfO4wQSlFvbDyfghbCnGI2uDI0a52zSrQ/yOA5A";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgZDBnj+gVMHqoNvjpx2T/HqnxUDbLPshu+t7301gXd Davi@DESKTOP-EVHFGJ9"
    ];
    extraGroups = [ "docker" ];
    packages = with pkgs; [
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pip
        python-pkgs.wheel
      ]))
    ];
  };

  services.nginx.virtualHosts."davikiwi.lelgenio.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:24618";
    };
  };
}
