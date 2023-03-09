{ pkgs, ... }: {
  networking.firewall.enable = false;

  services.mullvad-vpn.enable = true;
  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet allowSSH {
          chain allowIncoming {
              type filter hook input priority -100; policy accept;
              tcp dport 9022 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }
          chain allowOutgoing {
              type route hook output priority -100; policy accept;
              tcp sport 9022 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }
      }

      table inet allowNixServe {
          chain allowIncoming {
              type filter hook input priority -100; policy accept;
              tcp dport 5000 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }
          chain allowOutgoing {
              type route hook output priority -100; policy accept;
              tcp sport 5000 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }
      }
    '';
  };
}
