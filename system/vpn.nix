{ pkgs, lib, config, ... }:
let
  cfg = config.services.vpn;
in
{
  options.services.vpn = {
    enable = lib.mkEnableOption "Whether vpn should be enabled";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = false;

    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;

    networking.nftables = {
      enable = true;
      ruleset = ''
        table inet allowAll {
            chain allowIncoming {
                type filter hook input priority -100; policy accept;
                tcp dport 0-10999 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
            }
            chain allowOutgoing {
                type route hook output priority -100; policy accept;
                tcp sport 0-10999 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
            }
        }

        ######################################
        #       _            _               #
        #    __| | ___   ___| | _____ _ __   #
        #   / _` |/ _ \ / __| |/ / _ \ '__|  #
        #  | (_| | (_) | (__|   <  __/ |     #
        #   \__,_|\___/ \___|_|\_\___|_|     #
        #                                    #
        ######################################

        # This gets sent to the vpn so it's safe

        table ip nat {
            chain DOCKER {
                iifname "docker0" counter packets 0 bytes 0 return
            }

            chain POSTROUTING {
                type nat hook postrouting priority srcnat; policy accept;
                oifname != "docker0" ip saddr 172.17.0.0/16 counter packets 0 bytes 0 masquerade
            }

            chain PREROUTING {
                type nat hook prerouting priority dstnat; policy accept;
                fib daddr type local counter packets 5 bytes 252 jump DOCKER
            }

            chain OUTPUT {
                type nat hook output priority -100; policy accept;
                ip daddr != 127.0.0.0/8 fib daddr type local counter packets 0 bytes 0 jump DOCKER
            }
        }
        table ip filter {
            chain DOCKER {
            }

            chain DOCKER-ISOLATION-STAGE-1 {
                iifname "docker0" oifname != "docker0" counter packets 0 bytes 0 jump DOCKER-ISOLATION-STAGE-2
                counter packets 0 bytes 0 return
            }

            chain DOCKER-ISOLATION-STAGE-2 {
                oifname "docker0" counter packets 0 bytes 0 drop
                counter packets 0 bytes 0 return
            }

            chain FORWARD {
                type filter hook forward priority filter; policy accept;
                counter packets 0 bytes 0 jump DOCKER-USER
                counter packets 0 bytes 0 jump DOCKER-ISOLATION-STAGE-1
                oifname "docker0" ct state related,established counter packets 0 bytes 0 accept
                oifname "docker0" counter packets 0 bytes 0 jump DOCKER
                iifname "docker0" oifname != "docker0" counter packets 0 bytes 0 accept
                iifname "docker0" oifname "docker0" counter packets 0 bytes 0 accept
            }

            chain DOCKER-USER {
                counter packets 0 bytes 0 return
            }
        }

      '';
    };
  };
}
