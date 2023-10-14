let
  main_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxR/w+38b2lX90yNBqhq3mUmkn1WGu6GAPhN1tVp2ZjYRJNV/+5gWCnTtOWYtDx35HmK/spQ2Qy8X9ttkzORa24fysNx1Iqn/TiXhD7eIJjbGPnrOpIKTkW5/uB3SD/P5NBSa06//BaqJU4sBlG79hoXRpod052hQtdpTVDiMCIV+iboWPKqopmJJfWdBtVnHXs9rep0htPRExxGslImFk7Z6xjcaHyCpIQZPlOGf+sGsmUU7jRqzvZFV8ucIdbnAlMHrU4pepNFhuraESyZVTa/bi9sw0iozXp5Q5+5thMebEslmT1Z771kI4sieDy+O4r8c0Sx2/VY1UAzcpq1faggc3YB01MTh+tiEC6xdMvZLrQGL1NBWjHleMyL53GU5ERluC0vXJF3Hv3BGGBDfXWbrEm5n06DHr2apRVJGC0LwiQ7Woud1X4V4X1pKSusxCVMjT2lmcOwV6YhKhB2sowJc1OdMx4+tL0UWE+YKSZgBHfolwk6ml0F4EO9nnUHc= lelgenio@i15";
in
{
  "rainbow-gitlab-runner-thoreb-itinerario-registrationConfigFile.age".publicKeys = [ main_ssh_public_key ];
  "monolith-gitlab-runner-thoreb-itinerario-registrationConfigFile.age".publicKeys = [ main_ssh_public_key ];
  "gitlab-runner-thoreb-telemetria-registrationConfigFile.age".publicKeys = [ main_ssh_public_key ];
  "lelgenio-cachix.age".publicKeys = [ main_ssh_public_key ];
  "monolith-nix-serve-privkey.age".publicKeys = [ main_ssh_public_key ];
  "ghost-nextcloud.age".publicKeys = [ main_ssh_public_key ];
}
