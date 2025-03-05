{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops-master
    gnupg
  ];

  sops = {
    defaultSopsFile = ../secrets/test.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
