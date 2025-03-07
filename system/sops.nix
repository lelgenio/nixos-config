{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    gnupg
  ];

  sops = {
    defaultSopsFile = ../secrets/test.yaml;
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/lelgenio/.ssh/id_ed25519"
    ];
  };
}
